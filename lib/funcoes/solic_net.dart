import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:solicitacoes/controller/arq.dart';
import 'package:solicitacoes/controller/constantes.dart';
import 'package:solicitacoes/controller/usuarios.dart';
import 'package:solicitacoes/funcoes/date.dart';
import 'package:solicitacoes/funcoes/login.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/objetos/solicitacoes.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';

Future<ApiResponse> obtemCod() async {
  ctr = box.read('ctr') ?? '00000';
  var hDb = {"ctr": ctr};

  final body = jsonEncode(hDb);
  var urlComp = Uri.parse('$url$porta/solicitacao/obtemcod');

  try {
    var resposta = await http.post(
      urlComp,
      headers: {'Content-Type': 'application/json'},
      body: body,
    ).timeout(timeOut);
    try {
      var body = json.decode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);

      if (resposta.statusCode == 200) {
        box.write('cod', resp.data['proxCod']);
        return ApiResponse(
          sucesso: true,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      } else {
        return ApiResponse(
          sucesso: false,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      }
    } catch (e) {
      return ApiResponse(
        sucesso: false,
        mensagem: "Erro ao decodificar resposta",
      );
    }
  } catch (e) {
    return ApiResponse(
      sucesso: false,
      mensagem: "Erro ao se comunicar com o servidor",
    );
  }
}

Future<ApiResponse> salvaSolic() async {
  final arq = Get.find<ArquivosMob>();
  Solicitacoes solicitacao = Solicitacoes();
  List<Map<String, dynamic>> anexos =
      arq.anexos.map((file) {
        return {
          file.name: {"bytes": file.bytes},
        };
      }).toList();

  solicitacao = solicitacao.copyWith(
    cod: cod.text,
    dataEmissao: data.text,
    ctr: "${box.read('ctr')}",
    solicitante: "${box.read('login')}",
    status: "Pendente",
    prioridade: box.read('prioridade'),
    descricao: box.read('descricao'),
    anexos: anexos,
  );
  final body = solicitacao.toJson();
  var urlComp = Uri.parse('$url$porta/solicitacao/incluir');
  try {
    var resposta = await http.post(
      urlComp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ).timeout(timeOut);
    try {
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      if (resposta.statusCode == 200) {
        return resp;
      } else {
        return ApiResponse(sucesso: false, mensagem: resp.mensagem);
      }
    } catch (e) {
      return ApiResponse(
        sucesso: false,
        mensagem: "Erro ao descodificar resposta: ${e.toString()}",
      );
    }
  } catch (e) {
    return ApiResponse(
      sucesso: false,
      mensagem:
          "Falha na conexão. Verifique sua internet ou a conexao com o servidor.",
    );
  }
}

Future<ApiResponse> consultaSolic() async {
  Map<String, dynamic> requisicao = {
    "ctr": "${box.read('ctr')}",
    "nome": "${box.read('login')}",
  };
  if (!isSpeed()) {
    requisicao = {
      ...requisicao,
      "permissoes": {
        "Consultar Solicitacoes": box.read('Consultar Solicitacoes') ?? "",
      },
    };
  }

  var urlComp = Uri.parse('$url$porta/solicitacao/consultar');

  try {
    var resposta = await http.post(
      urlComp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requisicao),
    ).timeout(timeOut);
    try {
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      if (resposta.statusCode == 200) {
        if (resp.data != null) {
          return ApiResponse(
            sucesso: true,
            mensagem: resp.mensagem,
            data: resp.data,
          );
        } else {
          return ApiResponse(
            sucesso: false,
            mensagem: "Nenhuma solicitação encontrada",
            data: resp.data,
          );
        }
      } else {
        return ApiResponse(
          sucesso: false,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      }
    } catch (e) {
      return ApiResponse(
        sucesso: false,
        mensagem: "Falha ao decodificar resposta: ${e.toString()}",
      );
    }
  } catch (e) {
    return ApiResponse(
      sucesso: false,
      mensagem:
          "Falha na conexão. Verifique sua internet ou a conexao com o servidor.",
    );
  }
}

Future<ApiResponse> obtemSolic(String ctr, String cod) async {
  Map<String, String> requisicao = {"ctr": ctr, "cod": cod};

  var urlComp = Uri.parse('$url$porta/solicitacao/obtemsolic');

  try {
    var resposta = await http.post(
      urlComp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requisicao),
    ).timeout(timeOut);
    try {
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      log("Obteve a resposta ${resposta.statusCode}");
      if (resposta.statusCode == 200) {
        
        return ApiResponse(
          sucesso: true,
          mensagem: resp.mensagem,
          data: resp.data,
        );        
      } else {
        return ApiResponse(
          sucesso: false,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      }
    } catch (e) {
      return ApiResponse(
        sucesso: false,
        mensagem: "Falha ao decodificar resposta: ${e.toString()}",
      );
    }
  } catch (e) {
    return ApiResponse(
      sucesso: false,
      mensagem:
          "Falha na conexão. Verifique sua internet ou a conexao com o servidor.",
    );
  }
}

Future<ApiResponse> recusaSolic(Solicitacoes solic) async {
  Map<String, String> requisicao = {
    "ctr": solic.ctr ?? '',
    "cod": solic.cod ?? '',
    "dataConclusao": Data.getData,
    "tecnico": "${box.read('login')}",
    "status": "Recusada",
    "solucao": "${box.read('solucao')}",
  };

  var urlComp = Uri.parse('$url$porta/solicitacao/status');

  try {
    var resposta = await http.post(
      urlComp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requisicao),
    ).timeout(timeOut);
    try {
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      log("10");
      if (resposta.statusCode == 200) {
        log("11");
        return ApiResponse(
          sucesso: true,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      } else {
        log("12");
        return ApiResponse(
          sucesso: false,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      }
    } catch (e) {
      log("13");
      return ApiResponse(
        sucesso: false,
        mensagem: "Falha ao decodificar resposta: ${e.toString()}",
      );
    }
  } catch (e) {
    return ApiResponse(
      sucesso: false,
      mensagem:
          "Falha na conexão. Verifique sua internet ou a conexao com o servidor.",
    );
  }
}

Future<ApiResponse> concluiSolic(Solicitacoes solic) async {
  Map<String, String> requisicao = {
    "ctr": solic.ctr ?? '',
    "cod": solic.cod ?? '',
    "dataConclusao": Data.getData,
    "dev": "${box.read('login')}",
    "status": "Concluido",
    "solucao": "${box.read('solucao')}",
  };

  var urlComp = Uri.parse('$url$porta/solicitacao/status');

  try {
    var resposta = await http.post(
      urlComp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requisicao),
    ).timeout(timeOut);
    try {
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      log("10");
      if (resposta.statusCode == 200) {
        log("11");
        return ApiResponse(
          sucesso: true,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      } else {
        log("12");
        return ApiResponse(
          sucesso: false,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      }
    } catch (e) {
      log("13");
      return ApiResponse(
        sucesso: false,
        mensagem: "Falha ao decodificar resposta: ${e.toString()}",
      );
    }
  } catch (e) {
    return ApiResponse(
      sucesso: false,
      mensagem:
          "Falha na conexão. Verifique sua internet ou a conexao com o servidor.",
    );
  }
}

Future<ApiResponse> aceitaSolic(Solicitacoes solic) async {


  Map<String, String> requisicao = {
    "ctr": solic.ctr ?? '',
    "cod": solic.cod ?? '',
    "dataAceito": Data.getData,
    "tecnico": "${box.read('login')}",
    "status": "Desenvolvimento",
  };

  var urlComp = Uri.parse('$url$porta/solicitacao/status');

  try {
    var resposta = await http.post(
      urlComp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requisicao),
    ).timeout(timeOut);
    try {
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      if (resposta.statusCode == 200) {        
          return ApiResponse(
            sucesso: true,
            mensagem: resp.mensagem,
            data: resp.data,
          );                   
      } else {
        return ApiResponse(
          sucesso: false,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      }
    } catch (e) {
      return ApiResponse(
        sucesso: false,
        mensagem: "Falha ao decodificar resposta: ${e.toString()}",
      );
    }
  } catch (e) {
    return ApiResponse(
      sucesso: false,
      mensagem:
          "Falha na conexão. Verifique sua internet ou a conexao com o servidor.",
    );
  }
}


Future<ApiResponse> incluiTicket(String cod, String ctr) async {
  final arq = Get.find<ArquivosMob>();
  List<Map<String, dynamic>> anexos =
      arq.anexosTicket.map((file) {
        return {
          file.name: {"bytes": file.bytes},
        };
      }).toList();
  
  var requisicao = {
    "ctr": ctr,
    "cod": cod,
    "emissao": Data.getData,
    "solicitante": "${box.read('login')}" ,
    "descricao": box.read("ticket"),
    "anexos": anexos
  };

  var urlComp = Uri.parse('$url$porta/solicitacao/ticket');

  try {
    var resposta = await http.post(
      urlComp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requisicao),
    ).timeout(timeOut);
    try {
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      if (resposta.statusCode == 200) {        
          return ApiResponse(
            sucesso: true,
            mensagem: resp.mensagem,
            data: resp.data,
          );                   
      } else {
        return ApiResponse(
          sucesso: false,
          mensagem: resp.mensagem,
          data: resp.data,
        );
      }
    } catch (e) {
      return ApiResponse(
        sucesso: false,
        mensagem: "Falha ao decodificar resposta: ${e.toString()}",
      );
    }
  } catch (e) {
    return ApiResponse(
      sucesso: false,
      mensagem:
          "Falha na conexão. Verifique sua internet ou a conexao com o servidor.",
    );
  }
}
