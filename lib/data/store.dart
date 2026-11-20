import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/l10n/strings.dart';
import 'models/tx.dart';
import 'models/market.dart';

class Store extends ChangeNotifier {
  late SharedPreferences _p;
  List<Tx> tx = [];
  List<MkItem> items = [];
  List<Promo> promos = [];
  String apiKey = '';
  String lang = 'pt', profile = 'mod';
  int lastCat = 0;
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);

  List<Tx> get monthTx => tx.where((x) => x.date.year == month.year && x.date.month == month.month).toList();

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    final dev = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    lang = _p.getString('lang') ?? (kStrings.containsKey(dev) ? dev : 'pt');
    profile = _p.getString('profile') ?? 'mod';
    apiKey = _p.getString('ak') ?? '';
    lastCat = _p.getInt('lc') ?? 0;
    final mkRaw = _p.getString('mk');
    if (mkRaw != null) {
      final j = jsonDecode(mkRaw) as Map<String, dynamic>;
      items = (j['items'] as List).map((e) => MkItem.fromJson(e as Map<String, dynamic>)).toList();
      promos = (j['promos'] as List).map((e) => Promo.fromJson(e as Map<String, dynamic>)).toList();
    }
    final raw = _p.getString('tx');
    if (raw != null) {
      tx = (jsonDecode(raw) as List).map((e) => Tx.fromJson(e as Map<String, dynamic>)).toList();
    }
  }

  void _save() {
    _p.setString('tx', jsonEncode(tx.map((e) => e.toJson()).toList()));
    _p.setString('lang', lang);
    _p.setString('profile', profile);
    _p.setString('ak', apiKey);
    _p.setInt('lc', lastCat);
    _p.setString('mk', jsonEncode({'items': items.map((e) => e.toJson()).toList(), 'promos': promos.map((e) => e.toJson()).toList()}));
    notifyListeners();
  }

  void shift(int n) {
    month = DateTime(month.year, month.month + n);
    notifyListeners();
  }

  void setLang(String v) {
    lang = v;
    _save();
  }

  void setProfile(String v) {
    profile = v;
    _save();
  }

  void setKey(String v) {
    apiKey = v;
    _save();
  }

  void add({required bool income, required double v, required String d, required int c, required String m, required DateTime date, required bool later, required bool done, int n = 1}) {
    final base = DateTime.now().microsecondsSinceEpoch;
    final part = (v / n * 100).round() / 100;
    for (var i = 0; i < n; i++) {
      final when = i == 0 ? date : DateTime(date.year, date.month + i, date.day > 28 ? 28 : date.day);
      tx.add(Tx(id: '${base + i}', income: income, v: part, pv: (i == 0 && done) ? part : 0, d: n > 1 ? '$d (${i + 1}/$n)'.trim() : d, c: c, m: m, date: when, later: later));
    }
    if (!income) lastCat = c;
    month = DateTime(date.year, date.month);
    _save();
  }

  void remove(String id) {
    tx.removeWhere((e) => e.id == id);
    _save();
  }

  void pay(String id, double a) {
    final x = tx.firstWhere((e) => e.id == id);
    final rem = x.v - x.pv;
    x.pv = ((x.pv + (a > rem ? rem : a)) * 100).round() / 100;
    _save();
  }

  void undo(String id) {
    tx.firstWhere((e) => e.id == id).pv = 0;
    _save();
  }

  String _nid() => '${DateTime.now().microsecondsSinceEpoch}';

  void addItem(String n, double p, int q, {String? pid}) {
    items.add(MkItem(id: _nid(), n: n, p: p, q: q, pid: pid));
    _save();
  }

  void addPromo(String n, double p, String s) {
    promos.add(Promo(id: _nid(), n: n, p: p, s: s));
    _save();
  }

  void toggleItem(MkItem x) {
    x.done = !x.done;
    _save();
  }

  void delItem(String id) {
    items.removeWhere((e) => e.id == id);
    _save();
  }

  void delPromo(String id) {
    promos.removeWhere((e) => e.id == id);
    _save();
  }
}

final store = Store();
