

class MkItem {
  String id, n;
  double p;
  int q;
  bool done;
  String? pid;
  MkItem({required this.id, required this.n, required this.p, this.q = 1, this.done = false, this.pid});
  Map<String, dynamic> toJson() => {'id': id, 'n': n, 'p': p, 'q': q, 'd': done, 'pid': pid};
  factory MkItem.fromJson(Map<String, dynamic> j) => MkItem(id: j['id'] as String, n: j['n'] as String, p: (j['p'] as num).toDouble(), q: j['q'] as int, done: j['d'] as bool, pid: j['pid'] as String?);
}

class Promo {
  String id, n, s;
  double p;
  Promo({required this.id, required this.n, required this.p, this.s = ''});
  Map<String, dynamic> toJson() => {'id': id, 'n': n, 'p': p, 's': s};
  factory Promo.fromJson(Map<String, dynamic> j) => Promo(id: j['id'] as String, n: j['n'] as String, p: (j['p'] as num).toDouble(), s: j['s'] as String);
}
