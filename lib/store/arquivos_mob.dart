
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:mobx/mobx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:solicitacoes/funcoes/solic_net.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/objetos/solicitacoes.dart';

part 'arquivos_mob.g.dart';

class ArquivosMob = ArquivosMobBase with _$ArquivosMob;

abstract class ArquivosMobBase with Store { 

  @observable
  ObservableList<PlatformFile> anexos = ObservableList<PlatformFile>();

  @observable
  ObservableList<PlatformFile> anexosTicket = ObservableList<PlatformFile>();

  @observable
  ObservableList<PlatformFile> anexosSpeed = ObservableList<PlatformFile>();

  @observable
  ObservableMap<String, bool> filtros = ObservableMap<String, bool>.of({
    'Pendente': false,
    'Em Andamento': false,
    'Concluido': false,
    'Urgente': false,
    'Importante': false,
    'Normal': false,
  });

  @observable
  bool ticket = false;

  @observable
  ObservableList<Solicitacoes> solicitacoes = ObservableList<Solicitacoes>();

  @observable
  String termoBusca = '';

  @action
  void setTicket(bool valor) {
    ticket = valor;
  }

  @action
  void setTermoBusca(String valor) {
    termoBusca = valor;
  }
  
  
  @action
  void setFiltro(String chave, bool valor) {
    filtros[chave] = valor;
  }

  @computed
  List<Solicitacoes> get listaAlt {
    if (solicitacoes.isEmpty) return [];
    
    // return solicitacoes.toList();
    return solicitacoes.where((solic) {
      String status = solic.status?.toString().toLowerCase() ?? '';
      return status.contains('pendente');
    }).toList();
  }

// Em arquivos_mob.dart

@computed
List<Solicitacoes> get listaFiltrada {
  if (solicitacoes.isEmpty) return [];

  bool filtrarStatus = filtros['Pendente'] == true || 
                       filtros['Desenvolvimento'] == true || 
                       filtros['Concluido'] == true;

  bool filtrarPrioridade = filtros['Urgente'] == true || 
                           filtros['Importante'] == true || 
                           filtros['Normal'] == true;

  if (!filtrarStatus && !filtrarPrioridade && termoBusca.isEmpty) return solicitacoes;

  return solicitacoes.where((item) {
    bool statusOk = !filtrarStatus || filtros[item.status] == true;
    bool prioridadeOk = !filtrarPrioridade || filtros[item.prioridade] == true;
    bool buscaOk = termoBusca.isEmpty || 
                   (item.descricao?.toLowerCase().contains(termoBusca.toLowerCase()) ?? false);

    return statusOk && prioridadeOk && buscaOk;
  }).toList();
}

  @action
  Future<ApiResponse> obtemSolic() async{   
    try {      
      ApiResponse resp = await consultaSolic();
      if (resp.sucesso){
        List<dynamic> solicJson = resp.data;
        List<Solicitacoes> listaSolic = solicJson.map((json) => Solicitacoes.fromJson(json as Map<String, dynamic>)).toList();
        runInAction(() {
          solicitacoes.clear();
          solicitacoes.addAll(listaSolic);
        });
        for (var a = 0; a < listaSolic.length; a ++){
          log("Solicitacao ${listaSolic[a].cod} - ${listaSolic[a].descricao}");
        }
        return resp;
      }else {
        return resp;
      }            
    }catch (e) {
       return ApiResponse(
        sucesso: false, 
        mensagem: "Falha na conexão. Verifique sua internet ou a conexao com o servidor."
      );
    }
  }

  @action
  Future<void> montaAnexos(Solicitacoes solicitacao) async{
    anexos.clear();
    for (var anexo in solicitacao.anexos ?? []){      
      String nome = anexo["nomeArquivo"];
      String bytes = anexo["bytes"];      
      Uint8List bytesDecoded = base64Decode(bytes);
      PlatformFile arquivo = PlatformFile(name: nome, size: bytesDecoded.length, bytes: Uint8List.fromList(bytesDecoded));
      anexos.add(arquivo);
    }
  }

  @action
  Future<void> baixaAnexo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      anexos.addAll(result.files);            
    }
  }

  @action
  Future<void> baixaAnexoTicket() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      anexosTicket.addAll(result.files);            
    }
  }

  @action
  void removerAnexo(int index) {   
    anexos.removeAt(index);    
  }

  @action
  void removerAnexoTicket(int index) {   
    anexosTicket.removeAt(index);    
  }

  @action
  Future<void> baixaAnexoSpeed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      anexosSpeed.addAll(result.files);
    }
  }

  @action
  void removerAnexoSpeed(int index) {   
    anexosSpeed.removeAt(index);    
  }

  void resetCampos(){
    solicitacoes.clear();
    termoBusca = '';
    filtros = ObservableMap<String, bool>.of({
    'Pendente': false,
    'Em Andamento': false,
    'Concluido': false,
    'Urgente': false,
    'Importante': false,
    'Normal': false,
  });

  }

}
