import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as xl;

String cellText(xl.Data? c) {
  final v = c?.value;
  if (v == null) return '';
  if (v is xl.TextCellValue) {
    final dynamic x = v.value;
    return x is String ? x : (x as TextSpan).toPlainText();
  }
  if (v is xl.DateCellValue) return '${v.year}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}';
  if (v is xl.DateTimeCellValue) return '${v.year}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}';
  return v.toString();
}

String xlsxToText(List<int> b) {
  final ex = xl.Excel.decodeBytes(b);
  final o = StringBuffer();
  var n = 0;
  for (final sh in ex.tables.entries) {
    o.writeln('# ${sh.key}');
    for (final row in sh.value.rows) {
      if (n++ >= 400) break;
      final line = row.map(cellText).join(' | ');
      if (line.replaceAll('|', '').trim().isNotEmpty) o.writeln(line);
    }
  }
  return o.toString();
}
