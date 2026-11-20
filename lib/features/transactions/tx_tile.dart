import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/tx.dart';
import '../../data/store.dart';
import 'pay_sheet.dart';

Widget txTile(BuildContext c, Tx x) => ListTile(
      leading: IconButton(
        icon: Icon(x.done ? Icons.check_circle : (x.pv > 0 ? Icons.timelapse : Icons.radio_button_unchecked), color: x.done ? kOk : null),
        onPressed: () => x.done ? store.undo(x.id) : showPay(c, x),
      ),
      title: Text(x.d.isEmpty ? (x.income ? t('income') : cats[x.c]) : x.d),
      subtitle: Text([
        fmtDate(x.date),
        if (!x.income) cats[x.c],
        if (x.later) t('later'),
        if (x.pv > 0 && !x.done) '${money(x.pv)} / ${money(x.v)}',
      ].join(' · ')),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('${x.income ? '+' : '−'}${money(x.v)}', style: TextStyle(fontWeight: FontWeight.bold, color: x.income ? kOk : kBad)),
        IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => store.remove(x.id)),
      ]),
    );
