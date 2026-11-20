import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/store.dart';
import '../../widgets/common.dart';
import 'tx_tile.dart';

class ListPage extends StatelessWidget {
  final bool card;
  ListPage({super.key, required this.card});
  @override
  Widget build(BuildContext context) {
    final a = store.monthTx.where((x) => !card || (!x.income && x.m == 'c')).toList()..sort((p, q) => q.date.compareTo(p.date));
    return ListView(padding: const EdgeInsets.all(16), children: [
      monthBar(),
      if (card)
        appCard(Column(children: [
          Text(t('inv'), style: kGrey),
          Text(money(sumTx(a)), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ])),
      if (a.isEmpty)
        Padding(padding: const EdgeInsets.all(32), child: Center(child: Text(t('none'), style: kGrey)))
      else
        Card(child: Column(children: [for (final x in a) txTile(context, x)])),
    ]);
  }
}
