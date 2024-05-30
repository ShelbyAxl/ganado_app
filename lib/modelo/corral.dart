class Corral {
  int idCorral;
  String ubicacion;
  String noArete;

  Corral({
    required this.idCorral,
    required this.ubicacion,
    required this.noArete,
  });

  Map<String, dynamic> toJSON() {
    return {
      'IDCORRAL': idCorral,
      'UBICACION': ubicacion,
      'NOARETE': noArete,
    };
  }
}