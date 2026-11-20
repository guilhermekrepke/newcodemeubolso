import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/store.dart';
import '../../widgets/common.dart';
import 'widgets/dashboard_widgets.dart';
import '../transactions/tx_tile.dart';
import '../transactions/add_sheet.dart';
import '../market/market_tiles.dart';
import '../market/mk_sheet.dart';
import 'ai/ai_card.dart';

class Home extends StatelessWidget {
  Home({super.key});
  @override
  Widget build(BuildContext context) {
    final a = store.monthTx;
    final ei = a.where((x) => x.income).toList();
    final ee = a.where((x) => !x.income).toList();
    final inc = sumTx(ei), exp = sumTx(ee), left = inc - exp, now = paidTx(ei) - paidTx(ee);
    final mx = inc > exp ? inc : exp;
    final inv = sumTx(ee.where((x) => x.m == 'c'));
    final mtot = store.items.fold<double>(0, (s, x) => s + x.p * x.q);
    final cs = List.generate(8, (i) => MapEntry(i, sumTx(ee.where((x) => x.c == i)))).where((e) => e.value > 0).toList()..sort((p, q) => q.value.compareTo(p.value));
    Widget tip;
    if (left > 0) {
      final p = {'con': [80, 20, 0], 'mod': [50, 30, 20], 'bol': [30, 20, 50]}[store.profile]!;
      const ks = ['res', 'rf', 'rv'];
      tip = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < 3; i++)
          if (p[i] > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${t(ks[i])} · ${p[i]}%'), Text(money(left * p[i] / 100), style: kBold)]),
            ),
        const SizedBox(height: 8),
        Text(t('disc'), style: kGrey),
      ]);
    } else if (cs.isNotEmpty) {
      tip = Text('${t('neg')} ${cats[cs.first.key]}');
    } else {
      tip = Text(t('none'), style: kGrey);
    }
    final fl = [for (var k = -5; k <= 0; k++) monthFlow(DateTime(store.month.year, store.month.month + k))];
    final fm = fl.fold<double>(1, (s, r) => math.max(s, math.max(r[1], r[2])));
    final pe = a.where((x) => !x.done).toList()..sort((p, q) => p.date.compareTo(q.date));
    final rc = [...a]..sort((p, q) => q.date.compareTo(p.date));
    final pr = store.promos.reversed.take(3).toList();
    Widget empty() => Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(t('none'), style: kGrey));
    return ListView(padding: const EdgeInsets.all(16), children: [
      monthBar(),
      appCard(Column(children: [
        const Icon(Icons.account_balance_wallet_outlined, color: kAccent),
        const SizedBox(height: 8),
        Text(t('now'), style: kGrey),
        Text(money(now), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: now < 0 ? kBad : kOk)),
        Text('${t('left')}: ${money(left)}', style: kGrey),
      ])),
      const AiCard(),
      Row(children: [
        Expanded(child: kpiCard(Icons.south_west, kOk, t('income'), money(inc), '${t('got')}: ${money(paidTx(ei))}', 1)),
        const SizedBox(width: 12),
        Expanded(child: kpiCard(Icons.north_east, kBad, t('expense'), money(exp), '${t('paid')}: ${money(paidTx(ee))}', 1)),
      ]),
      Row(children: [
        Expanded(child: kpiCard(Icons.credit_card_outlined, kAccent, t('inv'), money(inv), '', 2)),
        const SizedBox(width: 12),
        Expanded(child: kpiCard(Icons.shopping_cart_outlined, kAccent, t('mk'), money(mtot), '${store.items.length} ${t('nItems')}', 3)),
      ]),
      Row(children: [
        quickAction(Icons.south_west, t('income'), () => showAdd(context, inc0: true)),
        const SizedBox(width: 8),
        quickAction(Icons.north_east, t('expense'), () => showAdd(context)),
        const SizedBox(width: 8),
        quickAction(Icons.credit_card_outlined, t('card'), () => showAdd(context, m0: 'c')),
        const SizedBox(width: 8),
        quickAction(Icons.shopping_cart_outlined, t('mk'), () => showMk(context)),
      ]),
      appCard(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        sectionHeader(Icons.bar_chart_outlined, 'flow'),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (final r in fl)
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [chartBar(r[1] / fm, kOk), const SizedBox(width: 4), chartBar(r[2] / fm, kBad)]),
                  const SizedBox(height: 6),
                  Text(r[0].toInt().toString().padLeft(2, '0'), style: const TextStyle(fontSize: 12, color: kMuted)),
                ]),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [legendDot(kOk, t('income')), const SizedBox(width: 16), legendDot(kBad, t('expense'))]),
      ])),
      appCard(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        progressBar(t('income'), inc, mx, kOk, sub: splitLabel(ei)),
        progressBar(t('expense'), exp, mx, kBad, sub: splitLabel(ee)),
      ])),
      appCard(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        sectionHeader(Icons.pie_chart_outline, 'where'),
        if (cs.isEmpty) Text(t('none'), style: kGrey),
        for (final e in cs) progressBar(cats[e.key], e.value, exp, kPrimary, sub: '${(e.value / exp * 100).round()}%'),
      ])),
      appCard(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        sectionHeader(Icons.credit_card_outlined, 'pays'),
        if (exp <= 0) Text(t('none'), style: kGrey),
        if (exp > 0)
          for (final e in {'x': 'cash', 'd': 'debit', 'c': 'credit'}.entries)
            progressBar(t(e.value), sumTx(ee.where((x) => x.m == e.key)), exp, kAccent, sub: '${(sumTx(ee.where((x) => x.m == e.key)) / exp * 100).round()}%'),
      ])),
      appCard(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [sectionHeader(Icons.account_balance_outlined, 'tips'), tip])),
      appCard(
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          sectionHeader(Icons.schedule, 'pend', pad: true),
          if (pe.isEmpty) empty(),
          for (final x in pe.take(4)) txTile(context, x),
        ]),
        pad: const EdgeInsets.symmetric(vertical: 16),
      ),
      if (pr.isNotEmpty)
        appCard(
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            sectionHeader(Icons.local_offer_outlined, 'mkPromo', pad: true),
            for (final x in pr) promoTile(x),
          ]),
          pad: const EdgeInsets.symmetric(vertical: 16),
        ),
      appCard(
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          sectionHeader(Icons.swap_horiz, 'recent', pad: true),
          if (rc.isEmpty) empty(),
          for (final x in rc.take(4)) txTile(context, x),
        ]),
        pad: const EdgeInsets.symmetric(vertical: 16),
      ),
    ]);
  }
}
