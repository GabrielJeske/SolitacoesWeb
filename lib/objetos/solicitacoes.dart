class Solicitacoes {
  String? cod;
  String? dataEmissao;
  String? dataAceito;
  String? dataConclusao;
  String? aceitou;
  String? versao;
  String? atualizaTecnico;
  String? ctr;
  String? solicitante;
  String? status;
  String? prioridade;
  String? descricao;
  String? solucao;
  List<dynamic>? anexos;
  List<dynamic>? anexosDev;
  List<dynamic>? chat;

  
  Solicitacoes({
    this.cod,
    this.dataEmissao,
    this.dataAceito,
    this.dataConclusao,
    this.ctr,
    this.solicitante,
    this.status,
    this.prioridade,
    this.descricao,
    this.solucao,
    this.anexos,
    this.chat,
    this.aceitou,
    this.versao,
    this.atualizaTecnico,
    this.anexosDev
  });

  Solicitacoes copyWith({
    String? cod,
    String? dataEmissao,
    String? dataAceito,
    String? dataConclusao,
    String? ctr,
    String? solicitante,
    String? status,
    String? prioridade,
    String? descricao,
    String? solucao,
    String? aceitou,
    String? versao,
    String? atualizaTecnico,
    List<dynamic>? anexos,
    List<dynamic>? chat,
    List<dynamic>? anexosDev    
  }) {
    return Solicitacoes(
      cod: cod ?? this.cod, 
      dataEmissao: dataEmissao ?? this.dataEmissao,
      dataAceito: dataAceito ?? this.dataAceito,
      dataConclusao: dataConclusao ?? this.dataConclusao,
      ctr: ctr ?? this.ctr,
      solicitante: solicitante ?? this.solicitante,
      status: status ?? this.status,
      prioridade: prioridade ?? this.prioridade,
      descricao: descricao ?? this.descricao,
      solucao: solucao ?? this.solucao,
      anexos: anexos ?? this.anexos,
      chat: chat ?? this.chat,
      aceitou: aceitou ?? this.aceitou,
      versao: versao ?? this.versao,
      atualizaTecnico: atualizaTecnico ?? this.atualizaTecnico,
      anexosDev: anexosDev ?? this.anexosDev
    );
  }

  factory Solicitacoes.fromJson(Map<String, dynamic> json) {
    return Solicitacoes(
      cod: json["cod"],
      dataEmissao: json["dataEmissao"],
      dataAceito: json["dataAceito"],
      dataConclusao: json["dataConclusao"],
      ctr: json["ctr"],
      solicitante: json["solicitante"],
      status: json["status"],
      prioridade: json["prioridade"],
      descricao: json["descricao"],
      solucao: json["solucao"],
      anexos: json["anexos"],
      chat: json["chat"],
      aceitou: json["aceitou"],
      versao: json["versao"],
      atualizaTecnico: json["atualizaTecnico"],
      anexosDev: json["anexosDev"]
    );
  }

  Map<String, dynamic> toJson() => {
    "cod" : cod,
    "dataEmissao" : dataEmissao,
    "dataAceito" : dataAceito,
    "dataConclusao" : dataConclusao,
    "ctr" : ctr,
    "solicitante" : solicitante,
    "status" : status,
    "prioridade" : prioridade,
    "descricao" : descricao,
    "solucao" : solucao,
    "anexos" : anexos,
    "chat" : chat,
    "aceitou" : aceitou,
    "versao" : versao,
    "atualizaTecnico" : atualizaTecnico,
    "anexosDev" : anexosDev
  };
  
}