part of 'create_inventario_bloc.dart';

abstract class CreateInventarioState extends Equatable {
  final List<dynamic> categorias;
  final int length;

  const CreateInventarioState({this.length = 0, this.categorias});

  @override
  List<Object> get props => [];
}

class CreateInventarioInitial extends CreateInventarioState {
  CreateInventarioInitial()
      : super(
          length: 0,
          categorias: [],
        );
}

class CategoriaSetState extends CreateInventarioState {
  final List<dynamic> newCategoria;
  final int newLength;

  CategoriaSetState(this.newCategoria, this.newLength)
      : super(categorias: newCategoria, length: newLength);
}
