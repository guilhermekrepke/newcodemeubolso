import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/utils/format.dart';
import '../../data/store.dart';

void showMk(BuildContext ctx, {bool promo = false}) {
  var isP = promo, q = 1;
  final n = TextEditingController(), p = TextEditingController(), st = TextEditingController();
  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (c) => StatefulBuilder(
      builder: (c, set) => Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(c).viewInsets.bottom + 16),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [ButtonSegment(value: false, label: Text(t('mkList'))), ButtonSegment(value: true, label: Text(t('mkPromo')))],
              selected: {isP},
              onSelectionChanged: (v) => set(() => isP = v.first),
            ),
            const SizedBox(height: 12),
            TextField(controller: n, autofocus: true, textCapitalization: TextCapitalization.sentences, decoration: InputDecoration(hintText: t('mkName'), border: const OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(
              controller: p,
              keyboardType: kNumKb,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: '0,00', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            if (isP)
              TextField(controller: st, decoration: InputDecoration(hintText: t('mkStore'), border: const OutlineInputBorder()))
            else
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t('mkQty')),
                DropdownButton<int>(value: q, items: [for (var i = 1; i <= 30; i++) DropdownMenuItem(value: i, child: Text('$i'))], onChanged: (v) => set(() => q = v!)),
              ]),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final v = double.tryParse(p.text.replaceAll(',', '.'));
                final nm = n.text.trim();
                if (nm.isEmpty || v == null || v <= 0) return;
                if (isP) {
                  store.addPromo(nm, v, st.text.trim());
                } else {
                  store.addItem(nm, v, q);
                }
                Navigator.pop(c);
              },
              child: Padding(padding: const EdgeInsets.all(12), child: Text(t('save'))),
            ),
          ]),
        ),
      ),
    ),
  );
}
