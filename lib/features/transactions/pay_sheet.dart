import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/tx.dart';
import '../../data/store.dart';

void showPay(BuildContext ctx, Tx x) {
  var full = true;
  final amt = TextEditingController();
  final rem = ((x.v - x.pv) * 100).round() / 100;
  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (c) => StatefulBuilder(
      builder: (c, set) => Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(c).viewInsets.bottom + 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(child: Text(x.d.isEmpty ? (x.income ? t('income') : cats[x.c]) : x.d, style: kHeading)),
          Center(child: Text('${t('rem')}: ${money(rem)}', style: kGrey)),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: [ButtonSegment(value: true, label: Text(t('tot'))), ButtonSegment(value: false, label: Text(t('part')))],
            selected: {full},
            onSelectionChanged: (s) => set(() => full = s.first),
          ),
          const SizedBox(height: 12),
          if (full)
            Center(child: Text(money(rem), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))
          else
            TextField(
              controller: amt,
              autofocus: true,
              keyboardType: kNumKb,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: '0,00', border: OutlineInputBorder()),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              final a = full ? rem : double.tryParse(amt.text.replaceAll(',', '.'));
              if (a == null || a <= 0) return;
              store.pay(x.id, a);
              Navigator.pop(c);
            },
            child: Padding(padding: const EdgeInsets.all(12), child: Text(t(x.income ? 'rec' : 'pay'))),
          ),
        ]),
      ),
    ),
  );
}
