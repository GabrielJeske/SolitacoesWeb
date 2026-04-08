class Tickets {
  String? cod;
  String? ctr;
  String? solicitante;
  String? emissao;
  String? descricao;
  List<dynamic>? anexos;
  

  
  Tickets({
    this.cod,
    this.ctr,
    this.solicitante,
    this.emissao,
    this.descricao,
    this.anexos,
  });

  factory Tickets.fromJson(Map<String, dynamic> json) {
    return Tickets(
      cod: json["cod"],
      ctr: json["ctr"], 
      solicitante: json["solicitante"], 
      emissao: json["emissao"], 
      descricao: json["descricao"], 
      anexos: json["anexos"], 
    );
  }

}