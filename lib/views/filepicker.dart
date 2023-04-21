import 'package:flutter/material.dart';
import 'package:hungry/interfaces/filepicker.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/models/core/recipe.dart';
import 'package:hungry/models/helper/recipe_helper.dart';
import 'package:hungry/views/screens/listaInventarios.dart';
import 'package:hungry/views/utils/AppColor.dart';
import 'package:hungry/views/widgets/appBar.dart';
import 'package:hungry/views/widgets/drawer_page.dart';
import 'package:hungry/views/widgets/loading.dart';

class FilePickerpage extends StatefulWidget {
  @override
  _FilePickerpageState createState() => _FilePickerpageState();
}

class _FilePickerpageState extends State<FilePickerpage> {
  TextEditingController searchInputController = TextEditingController();
  final List<Recipe> searchResult = RecipeHelper.sarchResultRecipe;
  final fp = FilkePickers();
  final service = ILogin();
  bool inState = false;
  var listaCodigos;

  @override
  void initState() {
    super.initState(); // Call the superclass' initState method.
    getCodes();
  }

  Future<void> getCodes() async {
    var lCodigos = await service.obtenerCodigos();
    setState(() {
      listaCodigos = lCodigos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget().appBar('SISTEMA'),
      drawer: MyDrawerWidget(),
      body: listaCodigos == null
          ? Center(
              child: Loading().loadingIndicator(),
            )
          : _view(context),
    );
  }

  Widget _view(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15,
            vertical: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sistema de Inventario',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Proxima Nova',
                ),
              ),
              SizedBox(height: 24),
              Column(
                children: [
                  _buttonWidget(
                    context,
                    Icons.file_upload_rounded,
                    'Cargar Inventario',
                    () async {
                      fp.pickFile(listaCodigos);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _buttonWidget(
                    context,
                    Icons.view_list_rounded,
                    'Revisar Inventarios',
                    () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaInventariosPage(
                            argumento: 'sistema',
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _buttonWidget(
                    context,
                    Icons.logout,
                    'Salir',
                    () async {
                      Navigator.pop(context);
                      // Aquí se podría implementar la lógica de cierre de sesión
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonWidget(
    BuildContext context,
    IconData iconData,
    String label,
    Function onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(iconData),
      label: Text(
        label,
        style: TextStyle(
          color: AppColor.secondary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Proxima Nova',
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColor.primarySoft,
        minimumSize: Size(150, 70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: AppColor.primarySoft,
            width: 2,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
    );
  }
}
