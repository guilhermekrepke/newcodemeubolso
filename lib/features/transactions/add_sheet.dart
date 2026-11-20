import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/store.dart';

void showAdd(BuildContext ctx, {bool inc0 = false, String m0 = 'x'}) {
  var income = inc0, later = false, done = m0 != 'c';
  var cat = store.lastCat, n = 2;
  var m = m0;
  final cur = DateTime.now();
  var date = cur;
  if (store.month.year != cur.year || store.month.month != cur.month) {
    final last = DateTime(store.month.year, store.month.month + 1, 0).day;
    date = DateTime(store.month.year, store.month.month, cur.day > last ? last : cur.day);
  }
  final amt = TextEditingController(), desc = TextEditingController();
  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (c) => StatefulBuilder(builder: (c, set) {
      void fix() => done = !later && (income || m != 'c');
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(c).viewInsets.bottom + 16),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [ButtonSegment(value: false, label: Text(t('expense'))), ButtonSegment(value: true, label: Text(t('income')))],
              selected: {income},
              onSelectionChanged: (s) => set(() {
                income = s.first;
                fix();
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amt,
              autofocus: true,
              keyboardType: kNumKb,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: '0,00', border: OutlineInputBorder()),
            ),
            if (!income) ...[
              const SizedBox(height: 12),
              Wrap(spacing: 8, children: [
                for (var i = 0; i < 8; i++) ChoiceChip(avatar: Icon(kCatIcons[i], size: 18), label: Text(cats[i]), selected: cat == i, onSelected: (_) => set(() => cat = i)),
              ]),
            ],
            const SizedBox(height: 12),
            TextField(controller: desc, decoration: InputDecoration(hintText: t('desc'), border: const OutlineInputBorder())),
            if (!income) ...[
              const SizedBox(height: 12),
              SegmentedButton<String>(
                showSelectedIcon: false,
                segments: [ButtonSegment(value: 'x', label: Text(t('cash'))), ButtonSegment(value: 'd', label: Text(t('debit'))), ButtonSegment(value: 'c', label: Text(t('credit')))],
                selected: {m},
                onSelectionChanged: (s) => set(() {
                  m = s.first;
                  fix();
                }),
              ),
            ],
            if (!income && m == 'c')
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t('inst')),
                DropdownButton<int>(value: n, items: [for (var i = 1; i <= 24; i++) DropdownMenuItem(value: i, child: Text('$i'))], onChanged: (v) => set(() => n = v!)),
              ]),
            const SizedBox(height: 12),
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [ButtonSegment(value: false, label: Text(t('asap'))), ButtonSegment(value: true, label: Text(t('later')))],
              selected: {later},
              onSelectionChanged: (s) => set(() {
                later = s.first;
                fix();
              }),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(t('date')),
              TextButton(
                onPressed: () async {
                  final d = await showDatePicker(context: c, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2100));
                  if (d != null) set(() => date = d);
                },
                child: Text(fmtDate(date)),
              ),
            ]),
            if (!later) CheckboxListTile(contentPadding: EdgeInsets.zero, title: Text(t(income ? 'got' : 'paid')), value: done, onChanged: (v) => set(() => done = v!)),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                final v = double.tryParse(amt.text.replaceAll(',', '.'));
                if (v == null || v <= 0) return;
                store.add(income: income, v: v, d: desc.text.trim(), c: cat, m: income ? '' : m, date: date, later: later, done: done, n: (!income && m == 'c') ? n : 1);
                Navigator.pop(c);
              },
              child: Padding(padding: const EdgeInsets.all(12), child: Text(t('save'))),
            ),
          ]),
        ),
      );
    }),
  );
}
