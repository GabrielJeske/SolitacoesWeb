import 'package:solicitacoes/objetos/tickets.dart';

class Solicitacoes {
  String? cod;
  String? ctr;
  String? solicitante;
  String? dataEmissao;
  String? dataAceito;
  String? tecnico;
  String? dataConclusao;
  String? dev;
  String? status;
  String? prioridade;
  String? descricao;
  String? solucao;
  List<dynamic>? anexos;
  List<Tickets>? tickets;

  
  Solicitacoes({
    this.cod,
    this.ctr,
    this.solicitante,
    this.dataEmissao,
    this.dataAceito,
    this.tecnico,
    this.dataConclusao,
    this.dev,
    this.status,
    this.prioridade,
    this.descricao,
    this.solucao,
    this.anexos,
    this.tickets
  });

  Solicitacoes copyWith({
    String? cod,
    String? ctr,
    String? solicitante,
    String? dataEmissao,
    String? dataAceito,
    String? tecnico,
    String? dataConclusao,
    String? dev,
    String? status,
    String? prioridade,
    String? descricao,
    String? solucao,
    List<dynamic>? anexos,
    List<Tickets>? tickets,
  }) {
    return Solicitacoes(
      cod: cod ?? this.cod, 
      ctr: ctr ?? this.ctr,
      solicitante: solicitante ?? this.solicitante,
      dataEmissao: dataEmissao ?? this.dataEmissao,
      dataAceito: dataAceito ?? this.dataAceito,
      tecnico: tecnico ?? this.tecnico,
      dataConclusao: dataConclusao ?? this.dataConclusao,
      dev: dev ?? this.dev,
      status: status ?? this.status,
      prioridade: prioridade ?? this.prioridade,
      descricao: descricao ?? this.descricao,
      solucao: solucao ?? this.solucao,
      anexos: anexos ?? this.anexos,
      tickets: tickets ?? this.tickets,
    );
  }

  factory Solicitacoes.fromJson(Map<String, dynamic> json) {

    var listFromJson = json["tickets"] as List?;
    List<Tickets> ticketsList = listFromJson != null
        ? listFromJson.map((c) => Tickets.fromJson(c)).toList()
        : [];

    return Solicitacoes(
      cod: json["cod"],
      ctr: json["ctr"],
      solicitante: json["solicitante"],
      dataEmissao: json["dataEmissao"],
      dataAceito: json["dataAceito"],
      tecnico: json["tecnico"],
      dataConclusao: json["dataConclusao"],
      dev: json["dev"],
      status: json["status"],
      prioridade: json["prioridade"],
      descricao: json["descricao"],
      solucao: json["solucao"],
      anexos: json["anexos"],
      tickets: ticketsList,     
    );
  }

  Map<String, dynamic> toJson() => {
    "cod" : cod,
    "ctr" : ctr,
    "solicitante" : solicitante,
    "dataEmissao" : dataEmissao,
    "dataAceito" : dataAceito,
    "tecnico" : tecnico,
    "dataConclusao" : dataConclusao,  
    "dev" : dev, 
    "status" : status,
    "prioridade" : prioridade,
    "descricao" : descricao,
    "solucao" : solucao,
    "anexos" : anexos,
    "tickets" : tickets,
  };
  
}