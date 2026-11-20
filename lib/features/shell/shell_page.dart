import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation.dart';
import '../home/home_page.dart';
import '../transactions/list_page.dart';
import '../settings/settings_page.dart';
import '../transactions/add_sheet.dart';
import '../market/mk_page.dart';
import '../market/mk_sheet.dart';

class Shell extends StatelessWidget {
  Shell({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: nav,
        builder: (_, i, __) {
          final pages = <Widget>[Home(), ListPage(card: false), ListPage(card: true), const MkPage(), SettingsPage()];
          return Scaffold(
            body: SafeArea(child: pages[i]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (i == 3) {
                  showMk(context);
                } else {
                  showAdd(context);
                }
              },
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: kCard,
              surfaceTintColor: Colors.transparent,
              selectedIndex: i,
              onDestinationSelected: (v) => nav.value = v,
              destinations: [
                NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: t('home')),
                NavigationDestination(icon: const Icon(Icons.swap_horiz), label: t('list')),
                NavigationDestination(icon: const Icon(Icons.credit_card_outlined), label: t('card')),
                NavigationDestination(icon: const Icon(Icons.shopping_cart_outlined), label: t('mk')),
                NavigationDestination(icon: const Icon(Icons.tune), label: t('set')),
              ],
            ),
          );
        },
      );
}
