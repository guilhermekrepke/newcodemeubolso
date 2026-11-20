import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../data/store.dart';
import '../../widgets/common.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
        appCard(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t('lang'), style: kHeading),
          DropdownButton<String>(
            isExpanded: true,
            value: store.lang,
            items: [for (final e in kLangs.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
            onChanged: (v) => store.setLang(v!),
          ),
        ])),
        appCard(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t('prof'), style: kHeading),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [for (final k in ['con', 'mod', 'bol']) ButtonSegment(value: k, label: Text(t(k)))],
            selected: {store.profile},
            onSelectionChanged: (s) => store.setProfile(s.first),
          ),
        ])),
        Padding(padding: const EdgeInsets.all(16), child: Center(child: Text(t('local'), style: kGrey))),
      ]);
}
