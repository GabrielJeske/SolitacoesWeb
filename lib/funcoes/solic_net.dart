import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:solicitacoes/controller/arq.dart';
import 'package:solicitacoes/controller/constantes.dart';
import 'package:solicitacoes/funcoes/date.dart';
import 'package:solicitacoes/funcoes/login.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/objetos/solicitacoes.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';


Future<ApiResponse> obtemCod () async{

  ctr = box.read('ctr') ?? '00000';
  log("$ctr");
  var hDb = {
              "ctr" : ctr
            };
            
  final body = jsonEncode(hDb);
  var urlComp = Uri.parse('$url$porta/solicitacao/obtemcod');     
  
  try{
    var resposta = await http.post(urlComp,headers: {'Content-Type': 'application/json'},body: body);    
    try{
      var body = json.decode(resposta.body); 
      ApiResponse resp = ApiResponse.fromMap(body);
      
      if (resposta.statusCode == 200){

        box.write('cod', resp.data['proxCod']);
        return ApiResponse(sucesso: true, mensagem: resp.mensagem);
      }else{
        return ApiResponse(sucesso: false, mensagem: resp.mensagem);
      }
    }catch(e){
      return ApiResponse(
        sucesso: false,
        mensagem: "Erro ao decodificar resposta"
      );  
    }    
  }catch(e){    
    return ApiResponse(
      sucesso: false,
      mensagem: "Erro ao se comunicar com o servidor"
    );
  } 
}

Future<void> salvaSolic() async{
  final arq = Get.find<ArquivosMob>(); 
  Solicitacoes solicitacao = Solicitacoes();
  List<Map<String, dynamic>> anexos = arq.anexos.map((file) {
    return {
        file.name: {
            "bytes": file.bytes,
        }
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
    anexos: anexos
  );
  final body = solicitacao.toJson();
  log(jsonEncode(body));
  var urlComp = Uri.parse('$url$porta/solicitacao/incluir');     
  try{
    await http.post(urlComp,headers: {'Content-Type': 'application/json'},body: jsonEncode(body));           
  }catch(e){    
     Get.defaultDialog(
      title: 'Erro de Conexão',
      middleText: e.toString(),      
    );
   
  } 
}
Future<void> excluirSolic() async{

  Map<String, dynamic> body = {
    "cod": cod.text,
    "ctr": "${box.read('ctr')}",
    "solicitante": "${box.read('login')}",
  };
  
  log(jsonEncode(body));
  var urlComp = Uri.parse('$url$porta/solicitacao/exclusao');     
  try{
    await http.post(urlComp,headers: {'Content-Type': 'application/json'},body: jsonEncode(body));           
  }catch(e){    
     Get.defaultDialog(
      title: 'Erro de Conexão',
      middleText: e.toString(),      
    );
   
  } 
}

Future<void> altSolic() async{
  final arq = Get.find<ArquivosMob>(); 
  Solicitacoes solicitacao = Solicitacoes();
  List<Map<String, dynamic>> anexos = arq.anexos.map((file) {
    return {
        file.name: {
            "bytes": file.bytes,
        }
    };
}).toList();
  
  solicitacao = solicitacao.copyWith(
    cod: cod.text,
    dataEmissao: data.text,
    ctr: "${box.read('ctr')}",
    solicitante: "${box.read('login')}",
    status: box.read('status'),
    prioridade: box.read('prioridade'),
    descricao: box.read('descricao'),
    anexos: anexos
  );
  final body = solicitacao.toJson();
  log(jsonEncode(body));
  var urlComp = Uri.parse('$url$porta/solicitacao/alterar');     
  try{
    await http.post(urlComp,headers: {'Content-Type': 'application/json'},body: jsonEncode(body));           
  }catch(e){    
     Get.defaultDialog(
      title: 'Erro de Conexão',
      middleText: e.toString(),      
    );
   
  } 
}


consultaSolic() async{
  
  Map <String, dynamic> requisicao = {
   "ctr": "${box.read('ctr')}",
    "solicitante": "${box.read('login')}",
  };

  var urlComp = Uri.parse('$url$porta/solicitacao/consultar');     
  try{
    var resp =  await http.post(urlComp,headers: {'Content-Type': 'application/json'},body: jsonEncode(requisicao));     
    log("Resposta: ${resp.body}");      
    var resposta = jsonDecode(resp.body);
    log("Obeteve e vai retornar a resposta");
    return resposta;
  }catch(e){    
     Get.defaultDialog(
      title: 'Erro de Conexão',
      middleText: e.toString(),      
    );
  } 
}

teste () async{
  var urlComp = Uri.parse('$url$porta/solicitacao/consultar'); 
  Map<String, dynamic> hDb = {
    "ctr": "09999",
    "solicitante": "GABRIEL",
    
  };
  try{
    log("$hDb");
    var resp =  await http.post(urlComp,headers: {'Content-Type': 'application/json'},body: jsonEncode(hDb));           
    var resposta = jsonDecode(resp.body);
    log("$resposta");
  }catch(e){    
     Get.defaultDialog(
      title: 'Erro de Conexão',
      middleText: e.toString(),      
    );
  } 
}

aceitaSolic(String codSolic) async{
  Solicitacoes solicitacao = Solicitacoes();

  solicitacao = solicitacao.copyWith(
    cod: codSolic,
    dataAceito: Data.getData,
    aceitou: "${box.read('login')}",
    status: "desenvolvimento",
  );
  final body = solicitacao.toJson();

  var urlComp = Uri.parse('$url$porta/solicitacao/aceitaSolic');     
  try{
    var resp =  await http.post(urlComp,headers: {'Content-Type': 'application/json'},body: jsonEncode(body));           
    List<dynamic> resposta = jsonDecode(resp.body);
    return resposta;
  }catch(e){    
     Get.defaultDialog(
      title: 'Erro de Conexão',
      middleText: e.toString(),      
    );
  } 

}

concluiSolic() async{

}
rejeitaSolic() async{

}

