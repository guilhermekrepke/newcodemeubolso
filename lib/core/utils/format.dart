import 'package:flutter/material.dart';
import '../../data/models/tx.dart';
import '../../data/store.dart';

String money(double v) {
  final dotDec = store.lang == 'en' || store.lang == 'zh';
  final parts = v.abs().toStringAsFixed(2).split('.');
  final ip = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => dotDec ? ',' : '.');
  return '${v < 0 ? '−' : ''}R\$ $ip${dotDec ? '.' : ','}${parts[1]}';
}

String fmtDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

double sumTx(Iterable<Tx> l) => l.fold<double>(0, (s, x) => s + x.v);

double paidTx(Iterable<Tx> l) => l.fold<double>(0, (s, x) => s + x.pv);

const kNumKb = TextInputType.numberWithOptions(decimal: true);
