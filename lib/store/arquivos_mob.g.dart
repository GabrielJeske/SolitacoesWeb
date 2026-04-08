// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivos_mob.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ArquivosMob on ArquivosMobBase, Store {
  Computed<List<Solicitacoes>>? _$listaAltComputed;

  @override
  List<Solicitacoes> get listaAlt =>
      (_$listaAltComputed ??= Computed<List<Solicitacoes>>(
            () => super.listaAlt,
            name: 'ArquivosMobBase.listaAlt',
          ))
          .value;
  Computed<List<Solicitacoes>>? _$listaFiltradaComputed;

  @override
  List<Solicitacoes> get listaFiltrada =>
      (_$listaFiltradaComputed ??= Computed<List<Solicitacoes>>(
            () => super.listaFiltrada,
            name: 'ArquivosMobBase.listaFiltrada',
          ))
          .value;

  late final _$anexosAtom = Atom(
    name: 'ArquivosMobBase.anexos',
    context: context,
  );

  @override
  ObservableList<PlatformFile> get anexos {
    _$anexosAtom.reportRead();
    return super.anexos;
  }

  @override
  set anexos(ObservableList<PlatformFile> value) {
    _$anexosAtom.reportWrite(value, super.anexos, () {
      super.anexos = value;
    });
  }

  late final _$anexosTicketAtom = Atom(
    name: 'ArquivosMobBase.anexosTicket',
    context: context,
  );

  @override
  ObservableList<PlatformFile> get anexosTicket {
    _$anexosTicketAtom.reportRead();
    return super.anexosTicket;
  }

  @override
  set anexosTicket(ObservableList<PlatformFile> value) {
    _$anexosTicketAtom.reportWrite(value, super.anexosTicket, () {
      super.anexosTicket = value;
    });
  }

  late final _$anexosSpeedAtom = Atom(
    name: 'ArquivosMobBase.anexosSpeed',
    context: context,
  );

  @override
  ObservableList<PlatformFile> get anexosSpeed {
    _$anexosSpeedAtom.reportRead();
    return super.anexosSpeed;
  }

  @override
  set anexosSpeed(ObservableList<PlatformFile> value) {
    _$anexosSpeedAtom.reportWrite(value, super.anexosSpeed, () {
      super.anexosSpeed = value;
    });
  }

  late final _$filtrosAtom = Atom(
    name: 'ArquivosMobBase.filtros',
    context: context,
  );

  @override
  ObservableMap<String, bool> get filtros {
    _$filtrosAtom.reportRead();
    return super.filtros;
  }

  @override
  set filtros(ObservableMap<String, bool> value) {
    _$filtrosAtom.reportWrite(value, super.filtros, () {
      super.filtros = value;
    });
  }

  late final _$ticketAtom = Atom(
    name: 'ArquivosMobBase.ticket',
    context: context,
  );

  @override
  bool get ticket {
    _$ticketAtom.reportRead();
    return super.ticket;
  }

  @override
  set ticket(bool value) {
    _$ticketAtom.reportWrite(value, super.ticket, () {
      super.ticket = value;
    });
  }

  late final _$solicitacoesAtom = Atom(
    name: 'ArquivosMobBase.solicitacoes',
    context: context,
  );

  @override
  ObservableList<Solicitacoes> get solicitacoes {
    _$solicitacoesAtom.reportRead();
    return super.solicitacoes;
  }

  @override
  set solicitacoes(ObservableList<Solicitacoes> value) {
    _$solicitacoesAtom.reportWrite(value, super.solicitacoes, () {
      super.solicitacoes = value;
    });
  }

  late final _$termoBuscaAtom = Atom(
    name: 'ArquivosMobBase.termoBusca',
    context: context,
  );

  @override
  String get termoBusca {
    _$termoBuscaAtom.reportRead();
    return super.termoBusca;
  }

  @override
  set termoBusca(String value) {
    _$termoBuscaAtom.reportWrite(value, super.termoBusca, () {
      super.termoBusca = value;
    });
  }

  late final _$obtemSolicAsyncAction = AsyncAction(
    'ArquivosMobBase.obtemSolic',
    context: context,
  );

  @override
  Future<ApiResponse> obtemSolic() {
    return _$obtemSolicAsyncAction.run(() => super.obtemSolic());
  }

  late final _$montaAnexosAsyncAction = AsyncAction(
    'ArquivosMobBase.montaAnexos',
    context: context,
  );

  @override
  Future<void> montaAnexos(Solicitacoes solicitacao) {
    return _$montaAnexosAsyncAction.run(() => super.montaAnexos(solicitacao));
  }

  late final _$baixaAnexoAsyncAction = AsyncAction(
    'ArquivosMobBase.baixaAnexo',
    context: context,
  );

  @override
  Future<void> baixaAnexo() {
    return _$baixaAnexoAsyncAction.run(() => super.baixaAnexo());
  }

  late final _$baixaAnexoTicketAsyncAction = AsyncAction(
    'ArquivosMobBase.baixaAnexoTicket',
    context: context,
  );

  @override
  Future<void> baixaAnexoTicket() {
    return _$baixaAnexoTicketAsyncAction.run(() => super.baixaAnexoTicket());
  }

  late final _$baixaAnexoSpeedAsyncAction = AsyncAction(
    'ArquivosMobBase.baixaAnexoSpeed',
    context: context,
  );

  @override
  Future<void> baixaAnexoSpeed() {
    return _$baixaAnexoSpeedAsyncAction.run(() => super.baixaAnexoSpeed());
  }

  late final _$ArquivosMobBaseActionController = ActionController(
    name: 'ArquivosMobBase',
    context: context,
  );

  @override
  void setTicket(bool valor) {
    final _$actionInfo = _$ArquivosMobBaseActionController.startAction(
      name: 'ArquivosMobBase.setTicket',
    );
    try {
      return super.setTicket(valor);
    } finally {
      _$ArquivosMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTermoBusca(String valor) {
    final _$actionInfo = _$ArquivosMobBaseActionController.startAction(
      name: 'ArquivosMobBase.setTermoBusca',
    );
    try {
      return super.setTermoBusca(valor);
    } finally {
      _$ArquivosMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFiltro(String chave, bool valor) {
    final _$actionInfo = _$ArquivosMobBaseActionController.startAction(
      name: 'ArquivosMobBase.setFiltro',
    );
    try {
      return super.setFiltro(chave, valor);
    } finally {
      _$ArquivosMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removerAnexo(int index) {
    final _$actionInfo = _$ArquivosMobBaseActionController.startAction(
      name: 'ArquivosMobBase.removerAnexo',
    );
    try {
      return super.removerAnexo(index);
    } finally {
      _$ArquivosMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removerAnexoTicket(int index) {
    final _$actionInfo = _$ArquivosMobBaseActionController.startAction(
      name: 'ArquivosMobBase.removerAnexoTicket',
    );
    try {
      return super.removerAnexoTicket(index);
    } finally {
      _$ArquivosMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removerAnexoSpeed(int index) {
    final _$actionInfo = _$ArquivosMobBaseActionController.startAction(
      name: 'ArquivosMobBase.removerAnexoSpeed',
    );
    try {
      return super.removerAnexoSpeed(index);
    } finally {
      _$ArquivosMobBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
anexos: ${anexos},
anexosTicket: ${anexosTicket},
anexosSpeed: ${anexosSpeed},
filtros: ${filtros},
ticket: ${ticket},
solicitacoes: ${solicitacoes},
termoBusca: ${termoBusca},
listaAlt: ${listaAlt},
listaFiltrada: ${listaFiltrada}
    ''';
  }
}
