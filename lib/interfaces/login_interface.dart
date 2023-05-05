import 'package:dio/dio.dart';
import 'package:hungry/constant/constant.dart';
import 'package:hungry/models/usuario/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/codigos.dart';
import '../models/usuario/loginModel.dart';

class ILogin {
  final dio = Dio();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<UsuarioModel> login(LoginRequestModel data) async {
    final api = ApiConstants.baseUrl + ApiConstants.loginUser;
    Response response = await dio.post(api, data: data);

    if (response.statusCode == 200) {
      final body = response.data;
      UsuarioModel a = UsuarioModel.fromJson(body);
      return a;
    } else {
      return null;
    }
  }

  Future<void> obtenerCategoria() async {
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final _tok = {'x-token': _token};
    final api = ApiConstants.baseUrl + ApiConstants.obtenerCategorias;
    Response response = await dio.get(api, queryParameters: _tok);
    if (response.statusCode == 200) {
      for (var value in response.data) {
        print(value[1]);
      }
    } else
      return 'error en los datos';
  }

  Future<List<dynamic>> obtenerInventarios() async {
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final _tok = {'x-token': _token};
    final api = ApiConstants.baseUrl + ApiConstants.crearInventario;
    Response response = await dio.get(api, queryParameters: _tok);
    if (response.statusCode == 200) {
      //print(response.data);
      final list = response.data['inventarios'];
      //print('lista : ${response.data}');
      return list;
    } else {
      throw Exception('Error en los datos');
    }
  }

  Future<List<dynamic>> obtenerInventariosBodega() async {
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final _tok = {'x-token': _token};
    final api = ApiConstants.baseUrl + ApiConstants.crearInventarioBodega;
    Response response = await dio.get(api, queryParameters: _tok);
    if (response.statusCode == 200) {
      final list = response.data['inventariosBodega'];

      return list;
    } else {
      throw Exception('Error en los datos');
    }
  }

  Future obtenerInventarioBodega(String id) async {
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final _tok = {'x-token': _token};

    final api =
        ApiConstants.baseUrl + ApiConstants.crearInventarioBodega + '/' + id;
    Response response = await dio.get(api, queryParameters: _tok);

    if (response.statusCode == 200) {
      final list = response.data;
      print('si obtuvo el invenatyrio : $list');
      return list;
    } else {
      throw Exception('Error en los datos');
    }
  }

  var cont = 0;
  Future crearInventario(data) async {
    cont = cont + 1;
    //print('entro al crear inventario: ${cont} ');
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final _tok = {'x-token': _token};
    final api = ApiConstants.baseUrl + ApiConstants.crearInventario;
    try {
      if (data == null) print('la data es mala');
      Response response =
          await dio.post(api, data: data, options: Options(headers: _tok));
      if (response.statusCode == 201) {
        print('201, response es : ${response.data}');
        return response.data;
      }
      return response;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future crearInventarioBodega(data) async {
    cont = cont + 1;
    //print('entro al crear inventario: ${cont} ');
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final _tok = {'x-token': _token};
    final api = ApiConstants.baseUrl + ApiConstants.crearInventarioBodega;
    try {
      if (data == null) print('la data es mala');
      Response response =
          await dio.post(api, data: data, options: Options(headers: _tok));
      if (response.statusCode == 201) {
        print('201, response es : ${response.data}');
        return response.data;
      }
      return response;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  addproductoInventarioBodega(data) async {
    final api = ApiConstants.baseUrl + ApiConstants.addProductoBodega;
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final _tok = {'x-token': _token};

    try {
      Response response =
          await dio.post(api, data: data, options: Options(headers: _tok));
      if (response.statusCode == 201) {
        print('lo agrego yu la respuesta e s: ${response.data}');
        return response.data;
      }
      return response;
    } on DioError catch (e) {
      print('no lo agrego, el error es : $e');
      return e.response.data;
    }
  }

  sendPostRequestWithToken(Map<String, Object> data) async {
    final api = ApiConstants.baseUrl + ApiConstants.addProducto;
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('token');
    try {
      final response = await dio.post(api,
          data: data, options: Options(headers: {'x-token': token}));
      //
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error en la solicitud   ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return null;
      } else {
        return null;
      }
    }
  }

  Future<List<dynamic>> obtenerCodigos() async {
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final _tok = {'x-token': _token};
    final api = ApiConstants.baseUrl + ApiConstants.cargarCodigo;
    Response response = await dio.get(api, queryParameters: _tok);
    if (response.statusCode == 200) {
      List list = response.data['codigos'];
      return list;
    } else {
      throw Exception('Error en los datos');
    }
  }

  agrega() async {
    List<Set<String>> listacodigos = Codigoslista().codigostotal();
    listacodigos.forEach((conjunto) {
      if (conjunto.isNotEmpty) {
        final a = conjunto.toList();
        print('ecostone=' + (a[1]) + '        fsl:' + (a[0]));
        final data = {'codigoFsl': a[0], 'codigoEcostone': a[1]};

        addcodigo(data);
      }
    });
  }

  addcodigo(data) async {
    final a = data;
    final api = ApiConstants.baseUrl + ApiConstants.cargarCodigo;
    final SharedPreferences prefs = await _prefs;
    final _token = prefs.getString('token');
    final response = await dio.post(api,
        data: a, options: Options(headers: {'x-token': _token}));
    if (response.statusCode == 400) return "error";
    return;
  }
}
