import '../store.dart';

class AiItem {
  bool inc, market, paid, on = true;
  double v;
  String d, m;
  int c, n;
  DateTime date;
  AiItem(this.inc, this.market, this.v, this.d, this.c, this.m, this.date, this.n, this.paid);

  static AiItem? from(Map<String, dynamic> j) {
    final type = j['type'];
    if (type != 'income' && type != 'expense' && type != 'market') return null;
    final market = type == 'market';
    final rawValue = j['value'];
    final parsedValue = rawValue is num
        ? rawValue.toDouble()
        : double.tryParse('$rawValue'.replaceAll(',', '.'));
    final v = market && rawValue == null ? 0.0 : parsedValue;
    if (v == null || !v.isFinite || v < 0 || (!market && v == 0)) return null;
    final inc = type == 'income';
    var date = DateTime.tryParse('${j['date']}') ?? DateTime.now();
    if (date.year < 2020 || date.year > 2100) date = DateTime.now();
    final day = DateTime(date.year, date.month, date.day);
    final rawCategory = j['category'];
    final category = rawCategory is num ? rawCategory.toInt() : int.tryParse('$rawCategory');
    final c = (category ?? 7).clamp(0, 7).toInt();
    final m = inc || market ? '' : (['x', 'd', 'c'].contains(j['method']) ? j['method'] as String : 'x');
    final rawQuantity = j['quantity'];
    final quantity = rawQuantity is num ? rawQuantity.toInt() : int.tryParse('$rawQuantity');
    final n = market
        ? (quantity ?? 1).clamp(1, 30).toInt()
        : (!inc && m == 'c')
            ? (int.tryParse('${j['installments']}') ?? 1).clamp(1, 24).toInt()
            : 1;
    final description = '${j['description'] ?? j['name'] ?? ''}'.trim();
    if (market && description.isEmpty) return null;
    final paid = j['paid'] != false && !day.isAfter(DateTime.now());
    return AiItem(inc, market, (v * 100).round() / 100, description, inc || market ? 0 : c, m, day, n, paid);
  }

  void save() {
    if (market) {
      store.addItem(d, v, n);
      return;
    }
    store.add(income: inc, v: v, d: d, c: c, m: m, date: date, later: !paid, done: paid && (inc || m != 'c'), n: n);
  }
}
