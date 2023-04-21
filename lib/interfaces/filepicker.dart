import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hungry/constant/listas.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'dart:async';

class FilkePickers {
  final services = ILogin();
  final listas = Abcd();
  List<String> extenciones = ['xlsx'];
  final pl = [];
  Sheet _sheetObject;
  var listaC;

  Future pickFile(listaCodigos) async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    final excel = Excel.decodeBytes(result.files.first.bytes);
    final sheeet = excel.getDefaultSheet();
    Sheet sheetObject = excel[sheeet];
    var rowLength = sheetObject.maxRows;
    var _list = listas.abc;

    var setLetra;

    final _descripcion = buscarCoordenadas(
        setLetra, _list, rowLength, sheetObject, 'Descripción'.toUpperCase());

    final _stock = buscarCoordenadas(
        setLetra, _list, rowLength, sheetObject, 'stock'.toUpperCase());

    final _codigo = buscarCoordenadas(
        setLetra, _list, rowLength, sheetObject, 'Código'.toUpperCase());

    if (result != null) {
      ordenar(_list, rowLength, sheetObject, _codigo, _descripcion, _stock,
          listaCodigos);
    }

    // return;
  }

  Future<void> ordenar(_list, rowLength, Sheet sheetObject, _codigo,
      _descriotion, stock, listaCodigos) async {
    var letra = _codigo[0];
    var _letraStock = stock[0];
    var _letraDescription = _descriotion[0];
    var _categoria = '';

    for (var i = 0; i <= rowLength; i++) {
      var cellDescripcion = sheetObject.cell(
          CellIndex.indexByString(_letraDescription + (i + 1).toString()));
      var cellCodigo =
          sheetObject.cell(CellIndex.indexByString(letra + (i + 1).toString()));
      var cellStock = sheetObject
          .cell(CellIndex.indexByString(_letraStock + (i + 1).toString()));
      if (cellCodigo.value != null && cellStock.value == null)
        _categoria = cellCodigo.value.toString();
      if (cellCodigo.value != null && cellStock.value != null) {
        final codigoEcostone =
            buscarPar(listaCodigos, cellCodigo.value.toString());
        if (codigoEcostone != null)
          addItem(cellCodigo.value.toString(), cellDescripcion.value.toString(),
              cellStock.value.toString(), _categoria, codigoEcostone);
      }
    }
    final fecha = DateTime.now();
    final ci = await services.crearInventario({'nombre': 'Inventario_$fecha'});
    final _id = ci['_id'];
    final Map<String, Object> data = {"_id": _id, "arrayDetalle": pl};
    await services.sendPostRequestWithToken(data);
    pl.clear();
  }

  addItem(codigo, descripcion, stock, categoria, codigoeso) {
    pl.add({
      "codigo": codigo,
      "descripcion": descripcion,
      "stock": stock,
      "categoria": categoria,
      "codigoFsl": codigoeso
    });
  }

  buscarPar(lista, cellCodigo) {
    for (var element in lista) {
      if (cellCodigo == element['codigoEcostone']) {
        return element['codigoFsl'];
      }
    }
  }

  buscarCoordenadas(setLetra, _list, rowLength, Sheet sheetObject, textBuscar) {
    for (var i = 0; i < listas.abc.length; i++) {
      setLetra = _list[i][i + 1];
      for (var x = 0; x <= rowLength; x++) {
        var cell = sheetObject.cell(
            CellIndex.indexByString(setLetra.toString() + (x + 1).toString()));
        while (cell.value.toString().toUpperCase() == textBuscar) {
          return [setLetra, x + 1];
        }
      }
    }
  }

  buscarValor(setLetra, _list, rowLength, Sheet sheetObject, textBuscar) {
    for (var i = 0; i < listas.abc.length; i++) {
      setLetra = _list[i][i + 1];
      for (var x = 0; x <= rowLength; x++) {
        var cell = sheetObject.cell(
            CellIndex.indexByString(setLetra.toString() + (x + 1).toString()));
        while (cell.value.toString().toUpperCase() == textBuscar) {
          return [setLetra, x + 1];
        }
      }
    }
  }

  Future<dynamic> buscarCodigo(String codigo) async {
    List<dynamic> codigos = await services.obtenerCodigos();
    for (var e in codigos) {
      if (e['codigoEcostone'].toString() == codigo) {
        final data = {
          'codigoFSL': e['codigoFsl'],
          'codigoECOSTONE': e['codigoEcostone']
        };
        //print(data);
        return data;
      }
    }
    return null;
  }
}
