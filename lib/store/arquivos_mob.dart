
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:solicitacoes/funcoes/solic_net.dart';
import 'package:solicitacoes/objetos/solicitacoes.dart';

part 'arquivos_mob.g.dart';

class ArquivosMob = ArquivosMobBase with _$ArquivosMob;

abstract class ArquivosMobBase with Store { 

  @observable
  ObservableList<PlatformFile> anexos = ObservableList<PlatformFile>();

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
  ObservableList<Solicitacoes> solicitacoes = ObservableList<Solicitacoes>();

  @observable
  String termoBusca = '';

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

  // 1. Verificar se estamos filtrando por Grupo
  // É necessário saber se "Alguém marcou Status" ou se "Alguém marcou Prioridade"
  // para não esconder itens indevidamente.
  
  bool filtrarStatus = filtros['Pendente'] == true || 
                       filtros['Em Andamento'] == true || 
                       filtros['Concluido'] == true;

  bool filtrarPrioridade = filtros['Urgente'] == true || 
                           filtros['Importante'] == true || 
                           filtros['Normal'] == true;

  // Se nada marcado, retorna tudo
  if (!filtrarStatus && !filtrarPrioridade) return solicitacoes;

  return solicitacoes.where((item) {
    // 2. Lógica Limpa e Direta
    
    // Se "filtrarStatus" é false (ninguém marcou status), então aceitamos TUDO (!false = true).
    // Se "filtrarStatus" é true, então obrigamos o item a bater com o filtro.
    bool statusOk = !filtrarStatus || filtros[item.status] == true;

    // Mesma lógica para prioridade
    bool prioridadeOk = !filtrarPrioridade || filtros[item.prioridade] == true;

    // Retorna apenas se passar nos dois critérios
    return statusOk && prioridadeOk;
  }).toList();
}
  // @computed
  // List<Solicitacoes> get listaFiltrada {
  //   if (solicitacoes.isEmpty) return [];

  //   return solicitacoes.where((solic) {
  //     // --- 1. FILTRO DE TEXTO ---
  //     // String ctr = solic.ctr?.toString().toLowerCase() ?? '';
  //     // String busca = termoBusca.toLowerCase();
  //     // bool matchTexto = busca.isEmpty || ctr.contains(busca);

  //     // Preparando os dados do item (tudo em minúsculo para comparar)
  //     String statusItem = solic.status?.toString().toLowerCase() ?? '';
  //     String prioridadeItem = solic.prioridade?.toString().toLowerCase() ?? '';
      
  //     // --- 2. GRUPO STATUS ---
  //     bool pende = filtros['pendente'] ?? false;
  //     bool anda = filtros['em andamento'] ?? false;
  //     bool conc = filtros['concluido'] ?? false;

  //     bool algumStatusMarcado = pende || anda || conc;
  //     bool matchStatus = false;

  //     if (!algumStatusMarcado) {
  //       // Se nenhum checkbox de status estiver marcado, mostramos TODOS os status
  //       matchStatus = true; 
  //     } else {
  //       // Se algum estiver marcado, verificamos se bate
  // if (pende && statusItem.contains('pendente')) matchStatus = true;
  // if (anda && statusItem.contains('em andamento'))  matchStatus = true;
  // if (conc && statusItem.contains('concluido')) matchStatus = true;
  //     }

  //     // --- 3. GRUPO PRIORIDADE (AQUI ESTAVA O PROBLEMA) ---
  //     bool urgente = filtros['urgente'] ?? false;
  //     bool importante = filtros['importante'] ?? false;
  //     bool normal = filtros['normal'] ?? false;

  //     bool algumaPrioMarcada = urgente || importante || normal;
  //     bool matchPrioridade = false;

  //     if (!algumaPrioMarcada) {
  //       // Se nenhuma prioridade marcada, mostramos TODAS as prioridades
  //       matchPrioridade = true; 
  //     } else {
  //       // Se alguma estiver marcada, verificamos se bate
  // if (urgente && prioridadeItem.contains('urgente')) matchPrioridade = true;
  // if (importante && prioridadeItem.contains('importante')) matchPrioridade = true;
  // if (normal && prioridadeItem.contains('normal')) matchPrioridade = true;
  //     }

  //     // --- RETORNO FINAL ---
  //     // O item precisa passar no Texto E no Status E na Prioridade
  //     return  matchStatus && matchPrioridade;
  //   }).toList();
  // }

  @action
  Future<void> obtemSolic() async{
    log("Obtendo solicitações...");
    try {
      log("Vai consultar");
      List<dynamic> solicJson = await consultaSolic();
      log("Esperou o await e consultou");
      List<Solicitacoes> listaSolic = solicJson.map((json) => Solicitacoes.fromJson(json as Map<String, dynamic>)).toList();
      log("Vai atualizar a lista das solicitacoes");
      runInAction(() {
          solicitacoes.clear();
          solicitacoes.addAll(listaSolic);
        });
     
      log("Atualizou e atribuiu a variavel Observalvel");
      // for (var anexosSolic in solicitacoes) { 
      //   for (var anexo in anexosSolic.anexos ?? []){
      //     log("anexo: $anexo");
      //     String nome = anexo["nomeArquivo"];
      //     String bytes = anexo["bytes"];
          
      //     Uint8List bytesDecoded = base64Decode(bytes);
      //     PlatformFile arquivo = PlatformFile(name: nome, size: bytesDecoded.length, bytes: Uint8List.fromList(bytesDecoded));
      //     anexos.add(arquivo);
      //   }
        
      // }
    }catch (e) {
      Get.defaultDialog(
        title: 'Erro ao obter as Solicitacoes',
        middleText: e.toString(),
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
  void removerAnexo(int index) {   
    anexos.removeAt(index);    
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

}
