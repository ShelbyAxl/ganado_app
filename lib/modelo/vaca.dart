class Vaca {
  String noArete;
  String raza;
  double peso;

  Vaca({
    required this.noArete,
    required this.raza,
    required this.peso,
  });

  Map<String, dynamic> toJSON() {
    return {
      'NOARETE': noArete,
      'RAZA': raza,
      'PESO': peso,
    };
  }
}
