import 'package:flutter/material.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/format.dart';
import '../../../data/models/ai_item.dart';

Future<bool?> showAiReview(BuildContext ctx, List<AiItem> it, List<String> sk) => showModalBottomSheet<bool>(
      context: ctx,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => StatefulBuilder(builder: (c, set) {
        final n = it.where((x) => x.on).length;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(c).size.height * .85),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(t('aiReview'), style: kHeading),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(shrinkWrap: true, children: [
                  for (final x in it)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: x.on,
                      onChanged: (v) => set(() => x.on = v!),
                      title: Text(x.d.isEmpty ? (x.inc ? t('income') : cats[x.c]) : x.d),
                      subtitle: Text([
                        '${fmtDate(x.date)}/${x.date.year}',
                        x.inc ? t('income') : cats[x.c],
                        if (!x.inc && x.m == 'c' && x.n > 1) '${x.n}x',
                        if (!x.paid) t('later'),
                      ].join(' · ')),
                      secondary: Text('${x.inc ? '+' : '−'}${money(x.v)}', style: TextStyle(fontWeight: FontWeight.bold, color: x.inc ? kOk : kBad)),
                    ),
                  if (sk.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('${t('aiSkip')}:', style: kGrey),
                    for (final e in sk) Text('• $e', style: kGrey),
                  ],
                ]),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: n == 0
                    ? null
                    : () {
                        for (final x in it.where((x) => x.on)) {
                          x.save();
                        }
                        Navigator.pop(c, true);
                      },
                child: Padding(padding: const EdgeInsets.all(12), child: Text('${t('aiReg')} ($n)')),
              ),
            ]),
          ),
        );
      }),
    );
