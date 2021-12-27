import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

Future readExcelFile(String fileName)async{

  ByteData data = await rootBundle.load("assets/$fileName");
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);
  int j=0;
  Map<int,  List<String> > map = {};
  for (var table in excel.tables.keys) {
  for (dynamic row in excel.tables[table]!.rows) {
    map[++j] = row ;
  }
}
  return map;
}

Future<List<String>> readTextFile({required String txtFileName}) async {

  String allFile =  await rootBundle.loadString('assets/$txtFileName');

  return allFile.split('\n');
}