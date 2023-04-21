import 'package:flutter/material.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/models/usuario/loginModel.dart';
import 'package:hungry/views/screens/home_page.dart';
import 'package:hungry/views/widgets/custom_text_field.dart';
import 'package:hungry/views/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/AppColor.dart';

class LoginModal extends StatefulWidget {
  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final log = ILogin();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _loading = false;
  final loading = Loading();

  Future<void> _setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('token', token);
  }

  Future _login() async {
    final req = LoginRequestModel(
      correo: _mailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _loading = true;
    });
    try {
      final r = await log.login(req);
      setState(() {
        _loading = false;
      });
      if (r.token == null) {
        loading.loadingIndicator();
      } else {
        await _setToken(r.token);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              'Error de inicio de sesión',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Revise su correo electrónico y contraseña e intente nuevamente.',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cerrar',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ingresar Datos',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'inter',
                      color: AppColor.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  CustomTextField(
                    title: 'Email',
                    hint: 'tuCorreo@email.com',
                    controller: _mailController,
                  ),
                  const SizedBox(height: 24.0),
                  CustomTextField(
                    controller: _passwordController,
                    title: 'Password',
                    hint: '**********',
                    obsecureText: true,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    child: _loading
                        ? SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.0,
                              letterSpacing: 1.0,
                              color: Colors.white60,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () {
                      _login();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
