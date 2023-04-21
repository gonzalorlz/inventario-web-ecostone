import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hungry/interfaces/login_interface.dart';
part 'create_inventario_event.dart';
part 'create_inventario_state.dart';

class CreateInventarioBloc
    extends Bloc<CreateInventarioEvent, CreateInventarioState> {
  final _services = ILogin();
  CreateInventarioBloc() : super(CreateInventarioInitial()) {
    on<CategoriasEvent>((event, emit) =>
        emit(CategoriaSetState(event.categorias, event.categoriasLength)));
    on((event, emit) async {
      var lista=await _services.obtenerInventarios();
      
      return lista;

      
    });
  }
}
