import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/navigation.dart';
import '../../../core/utils/format.dart';
import '../../../data/store.dart';
import '../../../widgets/common.dart';

Widget kpiCard(IconData i, Color c, String l, String v, String sub, int tab) => appCard(
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: c.withAlpha(30), borderRadius: BorderRadius.circular(10)), child: Icon(i, size: 20, color: c)),
        const SizedBox(height: 10),
        Text(l, style: kGrey),
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(v, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        Text(sub.isEmpty ? ' ' : sub, style: const TextStyle(fontSize: 12, color: kMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
      onTap: () => nav.value = tab,
    );

Widget quickAction(IconData i, String l, VoidCallback f) => Expanded(
      child: appCard(
        Column(children: [Icon(i, color: kAccent), const SizedBox(height: 6), Text(l, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))]),
        onTap: f,
        pad: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      ),
    );

Widget chartBar(double f, Color c) => Container(width: 14, height: math.max(3.0, f * 100), decoration: BoxDecoration(color: c, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))));

Widget legendDot(Color c, String l) => Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 10, height: 10, margin: const EdgeInsets.only(right: 6), decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      Text(l, style: kGrey),
    ]);

List<double> monthFlow(DateTime m) {
  final b = store.tx.where((x) => x.date.year == m.year && x.date.month == m.month);
  return [m.month.toDouble(), sumTx(b.where((x) => x.income)), sumTx(b.where((x) => !x.income))];
}
