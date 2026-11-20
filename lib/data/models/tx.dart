

class Tx {
  String id, d, m;
  bool income, later;
  double v, pv;
  int c;
  DateTime date;
  Tx({required this.id, required this.income, required this.v, this.pv = 0, this.d = '', this.c = 0, this.m = '', required this.date, this.later = false});
  bool get done => pv >= v - 0.001;
  Map<String, dynamic> toJson() => {'id': id, 'i': income, 'v': v, 'pv': pv, 'd': d, 'c': c, 'm': m, 'date': date.toIso8601String(), 'lt': later};
  factory Tx.fromJson(Map<String, dynamic> j) => Tx(
        id: j['id'] as String,
        income: j['i'] as bool,
        v: (j['v'] as num).toDouble(),
        pv: (j['pv'] as num).toDouble(),
        d: j['d'] as String,
        c: j['c'] as int,
        m: j['m'] as String,
        date: DateTime.parse(j['date'] as String),
        later: j['lt'] as bool,
      );
}
