import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/store.dart';
import '../../data/models/market.dart';

Widget mkItemTile(MkItem x) {
  final pm = store.promos.where((q) => q.n.trim().toLowerCase() == x.n.trim().toLowerCase() && q.p < x.p).toList()..sort((a, b) => a.p.compareTo(b.p));
  final hint = pm.isEmpty ? '' : '\n${t('mkBetter')}: ${money(pm.first.p)}';
  final price = x.p > 0 ? money(x.p) : '—';
  return ListTile(
    leading: IconButton(icon: Icon(x.done ? Icons.check_circle : Icons.radio_button_unchecked, color: x.done ? kOk : null), onPressed: () => store.toggleItem(x)),
    title: Text(x.n),
    subtitle: Text('${x.q} × $price$hint'),
    isThreeLine: pm.isNotEmpty,
    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
      if (x.p > 0) Text(money(x.p * x.q), style: kBold),
      IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => store.delItem(x.id)),
    ]),
  );
}

Widget promoTile(Promo p) {
  final on = store.items.any((x) => x.pid == p.id);
  return ListTile(
    title: Text(p.n),
    subtitle: Text(p.s.isEmpty ? money(p.p) : '${p.s} · ${money(p.p)}'),
    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
      TextButton(onPressed: on ? null : () => store.addItem(p.n, p.p, 1, pid: p.id), child: Text(t(on ? 'inList' : 'toList'))),
      IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => store.delPromo(p.id)),
    ]),
  );
}
