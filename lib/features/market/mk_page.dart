import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/store.dart';
import '../../widgets/common.dart';
import 'market_tiles.dart';

class MkPage extends StatefulWidget {
  const MkPage({super.key});
  @override
  State<MkPage> createState() => _MkPageState();
}

class _MkPageState extends State<MkPage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final it = store.items, pr = store.promos;
    final tot = it.fold<double>(0, (s, x) => s + x.p * x.q);
    final cart = it.where((x) => x.done).fold<double>(0, (s, x) => s + x.p * x.q);
    Widget empty() => Padding(padding: const EdgeInsets.all(32), child: Center(child: Text(t('none'), style: kGrey)));
    return ListView(padding: const EdgeInsets.all(16), children: [
      SegmentedButton<int>(
        showSelectedIcon: false,
        segments: [ButtonSegment(value: 0, label: Text(t('mkList'))), ButtonSegment(value: 1, label: Text(t('mkPromo')))],
        selected: {tab},
        onSelectionChanged: (v) => setState(() => tab = v.first),
      ),
      const SizedBox(height: 6),
      if (tab == 0) ...[
        appCard(Column(children: [Text(t('mkTotal'), style: kGrey), Text(money(tot), style: kBig), Text('${t('paid')}: ${money(cart)}', style: kGrey)])),
        if (it.isEmpty) empty() else appCard(Column(children: [for (final x in it) mkItemTile(x)]), pad: const EdgeInsets.symmetric(vertical: 8)),
      ] else ...[
        if (pr.isEmpty) empty() else appCard(Column(children: [for (final x in pr.reversed) promoTile(x)]), pad: const EdgeInsets.symmetric(vertical: 8)),
      ],
    ]);
  }
}
