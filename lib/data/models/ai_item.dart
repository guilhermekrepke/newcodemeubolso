import '../store.dart';

class AiItem {
  bool inc, paid, on = true;
  double v;
  String d, m;
  int c, n;
  DateTime date;
  AiItem(this.inc, this.v, this.d, this.c, this.m, this.date, this.n, this.paid);

  static AiItem? from(Map<String, dynamic> j) {
    final v = double.tryParse('${j['value']}'.replaceAll(',', '.'));
    if (v == null || v <= 0) return null;
    final inc = j['type'] == 'income';
    var date = DateTime.tryParse('${j['date']}') ?? DateTime.now();
    if (date.year < 2020 || date.year > 2100) date = DateTime.now();
    final day = DateTime(date.year, date.month, date.day);
    final c = (int.tryParse('${j['category']}') ?? 7).clamp(0, 7).toInt();
    final m = inc ? '' : (['x', 'd', 'c'].contains(j['method']) ? j['method'] as String : 'x');
    final n = (!inc && m == 'c') ? (int.tryParse('${j['installments']}') ?? 1).clamp(1, 24).toInt() : 1;
    final paid = j['paid'] != false && !day.isAfter(DateTime.now());
    return AiItem(inc, (v * 100).round() / 100, '${j['description'] ?? ''}'.trim(), inc ? 0 : c, m, day, n, paid);
  }

  void save() => store.add(income: inc, v: v, d: d, c: c, m: m, date: date, later: !paid, done: paid && (inc || m != 'c'), n: n);
}
