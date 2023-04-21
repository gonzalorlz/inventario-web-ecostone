class UsuarioModel {
  UsuarioModel({
    this.usuario,
    this.token,
  });
  Usuario usuario;
  String token;

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    usuario = Usuario.fromJson(json['usuario']);
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['usuario'] = usuario.toJson();
    _data['token'] = token;
    return _data;
  }
}

class Usuario {
  Usuario({
    this.rol,
    this.estado,
    this.google,
    this.nombre,
    this.correo,
    this.uid,
  });
  String rol;
  bool estado;
  bool google;
  String nombre;
  String correo;
  String uid;

  Usuario.fromJson(Map<String, dynamic> json) {
    rol = json['rol'];
    estado = json['estado'];
    google = json['google'];
    nombre = json['nombre'];
    correo = json['correo'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rol'] = rol;
    _data['estado'] = estado;
    _data['google'] = google;
    _data['nombre'] = nombre;
    _data['correo'] = correo;
    _data['uid'] = uid;
    return _data;
  }
}
