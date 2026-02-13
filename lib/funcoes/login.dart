import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:solicitacoes/controller/constantes.dart';
import 'package:solicitacoes/funcoes/autentica.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/store/login_mob.dart';


final box = GetStorage();

String?  ctr, login, senha = '';

LoginMob loginMob = Get.find<LoginMob>();

void resetLogin(){
  senha = '';
}

void validaTodosCampos(){
   validaCampos("ctr", ctr ?? "");
   validaCampos("login", login ?? "");
   validaCampos("senha", senha ?? "");
}

void setCampo(String chave, value) async{
  
  validaCampos(chave, value);

  switch (chave){
    case 'ctr':
      ctr =  value;
      box.write('ctr', value);
    break;
    case 'login':
      login =  value;
      box.write('login', value);
    break;    
    case 'senha':
      senha = value;
    break;
  }
}

void validaCampos(String chave, String value){
  if (value.isEmpty || value == ""){
     loginMob.formErrors[chave] = 'Prencha o campo';
  }else{
    switch (chave) {    
      case "ctr":   
        if (value.length != 5 || value.contains(RegExp(r'[^0-9]')) || value.isEmpty){
          loginMob.formErrors[chave] = 'Ctr inválido';      
        } else{
          loginMob.formErrors[chave] = null;
        }
        break;
      default:
        loginMob.formErrors[chave] = null;
        break;
    }
  }
}

Future<ApiResponse> fazLogin () async{
  
  ctr = box.read('ctr');
  login = box.read('login');
  
  String codig = chkIdent("$login$senha");
 
  Map<String, dynamic> req = {
    "ctr" :  ctr,
    "nome": login,
  };

  Map<String, dynamic> requisicao = {    
    ... req,
    "check": codig
  };

  var urlCompleta = Uri.parse("$url$porta/login");    

  try{
    var resposta = await http.post(
      urlCompleta,
      headers: {"Content-Type": "application/json"}, 
      body: json.encode(requisicao),
    );

    try{
      var body = jsonDecode(resposta.body);
      return ApiResponse.fromMap(body);
    } catch (e) {
      return ApiResponse(
        sucesso: false, 
        mensagem: "Erro no servidor (Resposta inválida): ${resposta.statusCode}"
      );
    }    
  }catch(e){
    return ApiResponse(
      sucesso: false, 
      mensagem: "Falha na conexão. Verifique sua internet ou a conexao com o servidor."
    );
  }
}

Future<ApiResponse> obtemPermissoesUser() async{

    ctr = box.read('ctr');
    login = box.read('login');

    Map<String, dynamic> req = {
      "ctr" :  ctr,
      "nome": login,
    };

    var urlCompleta = Uri.parse("$url$porta/usuarios/acessos");     
    try{
      var resposta =  await http.post(urlCompleta,headers: {'Content-Type': 'application/json'}, body: jsonEncode(req));        
        try{
          var body = jsonDecode(resposta.body);
          ApiResponse resp = ApiResponse.fromMap(body);  
          if (resposta.statusCode == 200)  {
            Map<dynamic,dynamic> acesso = resp.data;          
              acesso.forEach((chave,valor){
              box.write('$chave', valor);
            });
            return ApiResponse(sucesso: true, mensagem: "Permissões carregadas");
          } else {          
            return ApiResponse(sucesso: false, mensagem: "Erro ao descompactar resposta");
          }          
        } catch (e) {
          return ApiResponse(
            sucesso: false, 
            mensagem: "Erro no servidor (Resposta inválida): ${resposta.statusCode}"
          );
        }          
    }catch(e){    
      return ApiResponse(
      sucesso: false, 
      mensagem: "Falha na conexão. Verifique sua internet ou a conexao com o servidor."
    );
    } 
}


