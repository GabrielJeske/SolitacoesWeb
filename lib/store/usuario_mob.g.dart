// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_mob.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UsuarioMob on UsuarioMobBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(
            () => super.isFormValid,
            name: 'UsuarioMobBase.isFormValid',
          ))
          .value;
  Computed<List<Usuario>>? _$listaFiltradaComputed;

  @override
  List<Usuario> get listaFiltrada =>
      (_$listaFiltradaComputed ??= Computed<List<Usuario>>(
            () => super.listaFiltrada,
            name: 'UsuarioMobBase.listaFiltrada',
          ))
          .value;

  late final _$usuariosAtom = Atom(
    name: 'UsuarioMobBase.usuarios',
    context: context,
  );

  @override
  ObservableList<Usuario> get usuarios {
    _$usuariosAtom.reportRead();
    return super.usuarios;
  }

  @override
  set usuarios(ObservableList<Usuario> value) {
    _$usuariosAtom.reportWrite(value, super.usuarios, () {
      super.usuarios = value;
    });
  }

  late final _$alteracaoAtom = Atom(
    name: 'UsuarioMobBase.alteracao',
    context: context,
  );

  @override
  bool get alteracao {
    _$alteracaoAtom.reportRead();
    return super.alteracao;
  }

  @override
  set alteracao(bool value) {
    _$alteracaoAtom.reportWrite(value, super.alteracao, () {
      super.alteracao = value;
    });
  }

  late final _$acessosAtom = Atom(
    name: 'UsuarioMobBase.acessos',
    context: context,
  );

  @override
  ObservableList<String> get acessos {
    _$acessosAtom.reportRead();
    return super.acessos;
  }

  @override
  set acessos(ObservableList<String> value) {
    _$acessosAtom.reportWrite(value, super.acessos, () {
      super.acessos = value;
    });
  }

  late final _$filtrosAtom = Atom(
    name: 'UsuarioMobBase.filtros',
    context: context,
  );

  @override
  ObservableList<bool> get filtros {
    _$filtrosAtom.reportRead();
    return super.filtros;
  }

  @override
  set filtros(ObservableList<bool> value) {
    _$filtrosAtom.reportWrite(value, super.filtros, () {
      super.filtros = value;
    });
  }

  late final _$formErrorsAtom = Atom(
    name: 'UsuarioMobBase.formErrors',
    context: context,
  );

  @override
  ObservableMap<String, String?> get formErrors {
    _$formErrorsAtom.reportRead();
    return super.formErrors;
  }

  @override
  set formErrors(ObservableMap<String, String?> value) {
    _$formErrorsAtom.reportWrite(value, super.formErrors, () {
      super.formErrors = value;
    });
  }

  late final _$buscaAtom = Atom(name: 'UsuarioMobBase.busca', context: context);

  @override
  String get busca {
    _$buscaAtom.reportRead();
    return super.busca;
  }

  @override
  set busca(String value) {
    _$buscaAtom.reportWrite(value, super.busca, () {
      super.busca = value;
    });
  }

  late final _$exibeListaUsuariosAtom = Atom(
    name: 'UsuarioMobBase.exibeListaUsuarios',
    context: context,
  );

  @override
  bool get exibeListaUsuarios {
    _$exibeListaUsuariosAtom.reportRead();
    return super.exibeListaUsuarios;
  }

  @override
  set exibeListaUsuarios(bool value) {
    _$exibeListaUsuariosAtom.reportWrite(value, super.exibeListaUsuarios, () {
      super.exibeListaUsuarios = value;
    });
  }

  late final _$userSeleAtom = Atom(
    name: 'UsuarioMobBase.userSele',
    context: context,
  );

  @override
  Usuario get userSele {
    _$userSeleAtom.reportRead();
    return super.userSele;
  }

  @override
  set userSele(Usuario value) {
    _$userSeleAtom.reportWrite(value, super.userSele, () {
      super.userSele = value;
    });
  }

  late final _$antigoUserAtom = Atom(
    name: 'UsuarioMobBase.antigoUser',
    context: context,
  );

  @override
  Usuario get antigoUser {
    _$antigoUserAtom.reportRead();
    return super.antigoUser;
  }

  @override
  set antigoUser(Usuario value) {
    _$antigoUserAtom.reportWrite(value, super.antigoUser, () {
      super.antigoUser = value;
    });
  }

  late final _$obtemUsuariosAsyncAction = AsyncAction(
    'UsuarioMobBase.obtemUsuarios',
    context: context,
  );

  @override
  Future<ApiResponse> obtemUsuarios() {
    return _$obtemUsuariosAsyncAction.run(() => super.obtemUsuarios());
  }

  late final _$obtemListaAcessosAsyncAction = AsyncAction(
    'UsuarioMobBase.obtemListaAcessos',
    context: context,
  );

  @override
  Future<ApiResponse> obtemListaAcessos() {
    return _$obtemListaAcessosAsyncAction.run(() => super.obtemListaAcessos());
  }

  late final _$UsuarioMobBaseActionController = ActionController(
    name: 'UsuarioMobBase',
    context: context,
  );

  @override
  void setAlt(bool value) {
    final _$actionInfo = _$UsuarioMobBaseActionController.startAction(
      name: 'UsuarioMobBase.setAlt',
    );
    try {
      return super.setAlt(value);
    } finally {
      _$UsuarioMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBusca(String termo) {
    final _$actionInfo = _$UsuarioMobBaseActionController.startAction(
      name: 'UsuarioMobBase.setBusca',
    );
    try {
      return super.setBusca(termo);
    } finally {
      _$UsuarioMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFiltro(int chave, bool valor) {
    final _$actionInfo = _$UsuarioMobBaseActionController.startAction(
      name: 'UsuarioMobBase.setFiltro',
    );
    try {
      return super.setFiltro(chave, valor);
    } finally {
      _$UsuarioMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setListaUsuarios(bool value) {
    final _$actionInfo = _$UsuarioMobBaseActionController.startAction(
      name: 'UsuarioMobBase.setListaUsuarios',
    );
    try {
      return super.setListaUsuarios(value);
    } finally {
      _$UsuarioMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetFiltros() {
    final _$actionInfo = _$UsuarioMobBaseActionController.startAction(
      name: 'UsuarioMobBase.resetFiltros',
    );
    try {
      return super.resetFiltros();
    } finally {
      _$UsuarioMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selecUser(Usuario usuarioSelec) {
    final _$actionInfo = _$UsuarioMobBaseActionController.startAction(
      name: 'UsuarioMobBase.selecUser',
    );
    try {
      return super.selecUser(usuarioSelec);
    } finally {
      _$UsuarioMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
usuarios: ${usuarios},
alteracao: ${alteracao},
acessos: ${acessos},
filtros: ${filtros},
formErrors: ${formErrors},
busca: ${busca},
exibeListaUsuarios: ${exibeListaUsuarios},
userSele: ${userSele},
antigoUser: ${antigoUser},
isFormValid: ${isFormValid},
listaFiltrada: ${listaFiltrada}
    ''';
  }
}
