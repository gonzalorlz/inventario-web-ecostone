// ignore_for_file: non_constant_identifier_names

part of 'create_inventario_bloc.dart';

abstract class CreateInventarioEvent extends Equatable {
  const CreateInventarioEvent();

  @override
  List<Object> get props => [];
}

class CategoriasEvent extends CreateInventarioEvent {
  final List<dynamic> categorias;
  final int categoriasLength;

  CategoriasEvent(this.categorias, this.categoriasLength);
}

