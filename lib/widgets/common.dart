import 'package:flutter/material.dart';
import '../core/l10n/strings.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/format.dart';
import '../data/models/tx.dart';
import '../data/store.dart';

Widget appCard(Widget child, {VoidCallback? onTap, EdgeInsets pad = const EdgeInsets.all(16)}) => Card(
      color: kCard,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xFF2E2E36))),
      child: InkWell(onTap: onTap, child: Padding(padding: pad, child: child)),
    );

Widget sectionHeader(IconData i, String k, {bool pad = false}) => Padding(
      padding: EdgeInsets.fromLTRB(pad ? 16 : 0, 0, pad ? 16 : 0, 8),
      child: Row(children: [Icon(i, size: 18, color: kAccent), const SizedBox(width: 8), Text(t(k), style: kHeading)]),
    );

Widget monthBar() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(onPressed: () => store.shift(-1), icon: const Icon(Icons.chevron_left)),
      Text('${store.month.month.toString().padLeft(2, '0')}/${store.month.year}', style: kHeading),
      IconButton(onPressed: () => store.shift(1), icon: const Icon(Icons.chevron_right)),
    ]);

Widget progressBar(String l, double v, double mx, Color col, {String? sub}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l), Text(money(v), style: kBold)]),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: mx <= 0 ? 0 : (v / mx).clamp(0.0, 1.0), minHeight: 8, color: col, backgroundColor: kMuted.withAlpha(50)),
        ),
        if (sub != null) Text(sub, style: const TextStyle(fontSize: 12, color: kMuted)),
      ]),
    );

String splitLabel(List<Tx> l) => '${t('asap')}: ${money(sumTx(l.where((x) => !x.later)))} · ${t('later')}: ${money(sumTx(l.where((x) => x.later)))}';
