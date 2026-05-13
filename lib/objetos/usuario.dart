class Usuario {
  String? ctr;
  String? nome;
  String? check;
  String? cel;
  String? email;
  String? cargo;
  Map<String, String>? permissoes;

  
  Usuario({
    this.ctr,
    this.nome,
    this.cel,
    this.email,
    this.cargo,
    this.check,
    this.permissoes
  });

  Usuario copyWith({
    String? ctr,
    String? nome,
    String? cel,
    String? email,
    String? cargo,
    String? check,
    Map<String, String>? permissoes,
  }) {
    return Usuario(
      ctr: ctr ?? this.ctr, 
      nome: nome ?? this.nome,
      check: check ?? this.check,
      cel: cel ?? this.cel,
      email: email ?? this.email,
      cargo: cargo ?? this.cargo,
      permissoes: permissoes ?? this.permissoes
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      ctr: json["ctr"],
      nome: json["nome"],
      check: json["check"],
      cel: json["cel"],
      email: json["email"],
      cargo: json["cargo"],
      permissoes: json["permissoes"] != null 
          ? Map<String, String>.from(json["permissoes"]) 
          : null,
      
    );
  }

  Map<String, dynamic> toJson() => {
    "ctr" : ctr,
    "nome" : nome,
    "check" : check,
    "cel" : cel,
    "email" : email,
    "cargo" : cargo,
    "permissoes" : permissoes,    
  };
  
}