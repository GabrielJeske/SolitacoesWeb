
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:solicitacoes/controller/constantes.dart';
import 'package:solicitacoes/funcoes/autentica.dart';
import 'package:solicitacoes/funcoes/login.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/objetos/usuario.dart';
import 'package:solicitacoes/store/usuario_mob.dart';

final TextEditingController nomeController = TextEditingController();
final TextEditingController senhaController = TextEditingController();
final TextEditingController ctrController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController numeroController = TextEditingController();
final TextEditingController cargoController = TextEditingController();

Usuario usuario = Usuario();
Usuario usuarioAntigo = Usuario();
UsuarioMob usuarioMob = Get.find<UsuarioMob>();
String passwd = "" ;
Map<String,String> listaAcessos = {};


void validaCampos(String chave, String value){
  log("Vai validar o campo $chave com o valor $value");
  if (value.isEmpty || value == ""){
    usuarioMob.formErrors[chave] = 'Prencha o campo';
  }else{
    switch (chave) {
      case "email":
        final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          usuarioMob.formErrors[chave] = 'E-mail inválido' ;
        }else {
          usuarioMob.formErrors[chave] = null;
        }
        break;
      case "ctr":   
        if (value.length != 5 || value.contains(RegExp(r'[^0-9]')) || value.isEmpty){
          usuarioMob.formErrors[chave] = 'Ctr inválido';      
        } else{
          usuarioMob.formErrors[chave] = null;
        }
        break;
      default:
        usuarioMob.formErrors[chave] = null;
        break;
    }
  }
}

void validaSenha(){
  validaCampos("senha", senhaController.text);
}
void validaTodosCampos(){
  if (isSpeed()){
    validaCampos("ctr", ctrController.text);    
  }else {
    String ctr = box.read("ctr");
    setCampo("ctr", ctr);
    validaCampos("ctr", ctr);
  } 
  
  validaCampos("nome", nomeController.text);
  validaCampos("senha", senhaController.text);
  validaCampos("email", emailController.text);
  validaCampos("cel", numeroController.text);
  validaCampos("cargo", cargoController.text);
  
}

void validaAlteracao(){
  String ctr = '';
  
  if(isSpeed()){
     ctr = usuarioMob.antigoUser.ctr ?? "";
  }else {
     ctr = box.read("ctr");
  }
  log( "CTr: $ctr");
  validaCampos("ctr", ctr);  
  validaCampos("nome", nomeController.text);
  validaCampos("senha", senhaController.text);
  validaCampos("email", emailController.text);
  validaCampos("cel", numeroController.text);
  validaCampos("cargo", cargoController.text);
  
}

setCampo (String campo, String value ){
  
  validaCampos(campo, value);

  switch (campo) {
    case "ctr":            
      usuario = usuario.copyWith(ctr: value);
      break;
    case "nome":
      usuario = usuario.copyWith(nome: value);
      break;                 
    case "cel":
      usuario = usuario.copyWith(cel: value);
      break;
    case "email":
      usuario = usuario.copyWith(email: value);
      break;
    case "cargo":
      usuario = usuario.copyWith(cargo: value);
      break;
    case "senha":      
      passwd = value;
    break;
  }
}
 bool isSpeed() {
  String ctr = box.read("ctr");
  if (ctr == "09999"){
    return true;
  }else{
    return false;
  }
}

void resetUsuario (){
  
  nomeController.value = TextEditingValue.empty;
  senhaController.value = TextEditingValue.empty;
  ctrController.value = TextEditingValue.empty;
  emailController.value = TextEditingValue.empty;
  numeroController.value = TextEditingValue.empty;
  cargoController.value = TextEditingValue.empty;
  usuario = usuario.copyWith(
    cargo: "",
    cel: "",
    check: "",
    ctr: "",
    email: "",
    nome: "",
    permissoes: {}
  );
  usuarioMob.formErrors.clear();
  usuarioMob.resetFiltros();

}


Future<ApiResponse> consultaUsuarios() async{

  String ctr = box.read("ctr");

  Map<String, String> req = {
    "ctr" :  ctr
  };
  var urlCompleta = Uri.parse("$url$porta/usuarios/consulta");     
  try{
    var resposta =  await http.post(urlCompleta,headers: {'Content-Type': 'application/json'},body: jsonEncode(req)); 
    try{
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      if (resposta.statusCode == 200){
        return ApiResponse(sucesso: true, mensagem: "Sucesso ao consultar Usuarios", data: resp.data);
      }else{
        return ApiResponse(sucesso: true, mensagem: "Erro ao consultar usuarios ${resposta.statusCode}");
      }
    }catch(e){
      return ApiResponse(
      sucesso: false, 
      mensagem: "Falha na conexão. Verifique sua internet ou a conexao com o servidor."
      );
    }
  }catch(e){    
    return ApiResponse(
      sucesso: false, 
      mensagem: "Falha na conexão. Verifique sua internet ou a conexao com o servidor."
    );
  } 
}

montaPermissao(){
  int limite = usuarioMob.acessos.length;

  for (var i = 0; i < limite; i ++) {   
    int iIndice = i*2;
    int jIndice = iIndice + 2;  
    for (var j = iIndice; j < jIndice; j++) {         
      if (usuarioMob.filtros[j] == true){        
        if (j.isEven){          
          listaAcessos[usuarioMob.acessos[i]] = "proprio";          
        }else if (j.isOdd){          
         listaAcessos[usuarioMob.acessos[i]] = "geral";         
        }        
      }
    }    
  }
  
}

montaCheck(){
  String login = usuario.nome ?? "";
  log("Vai fazer o chkIdent com $login $passwd");
  String codig = chkIdent("$login$passwd");
  usuario = usuario.copyWith(permissoes: listaAcessos, check: codig);
}

Future<ApiResponse> incluirUsuario() async{
  montaPermissao();
  montaCheck();
  var urlCompleta = Uri.parse("$url$porta/usuarios/incluir");     
  var req = usuario.toJson();
  try{
     log("$req");
    var resposta =  await http.post(urlCompleta,headers: {'Content-Type': 'application/json'},body: jsonEncode(req));   
    log("Resposta obteve o status = ${resposta.statusCode}");
    try{
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);      
      if (resposta.statusCode == 200){
        return ApiResponse(sucesso: true, mensagem: resp.mensagem);
      }else{
        return ApiResponse(
        sucesso: false, 
        mensagem: "Erro no servidor (Resposta inválida): ${resp.mensagem}"
      );
      }      
    }catch (e){
       return ApiResponse(
        sucesso: false, 
        mensagem: "Erro ao descodificar resposta: ${e.toString()}"
      );
    }   
  }catch(e){    
    return ApiResponse(
      sucesso: false, 
      mensagem: "Falha na conexão. Verifique sua internet ou a conexao com o servidor."
    );
  } 
}

Future<ApiResponse> alterarUsuario() async{
  if (isSpeed()){
    usuario.ctr = usuarioMob.antigoUser.ctr ?? "";
  }else {
    usuario.ctr = box.read("ctr") ?? "";
  }
 
  montaPermissao();
  montaCheck();
  var urlCompleta = Uri.parse("$url$porta/usuarios/alterar");   

  
  usuarioAntigo = usuarioAntigo.copyWith(
    cargo: usuarioMob.antigoUser.cargo,
    cel: usuarioMob.antigoUser.cel,
    check: usuarioMob.antigoUser.check,
    ctr: usuarioMob.antigoUser.ctr,
    email: usuarioMob.antigoUser.email,
    nome: usuarioMob.antigoUser.nome,
    permissoes: usuarioMob.antigoUser.permissoes  
  );
  
  var antigo = usuarioAntigo.toJson();
  var novo = usuario.toJson();
  Map<String, dynamic> req = {
    "antigo" : antigo,
    "novo" : novo
  }; 
  
  try{
    var resposta =  await http.post(urlCompleta,headers: {'Content-Type': 'application/json'},body: jsonEncode(req)); 
    try{
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      if (resposta.statusCode == 200){
        return ApiResponse(sucesso: true, mensagem: resp.mensagem);
      }else{
        return ApiResponse(sucesso: false, mensagem: resp.mensagem);
      }
    }catch(e){
      return ApiResponse(
        sucesso: false,
        mensagem: "Falha ao descodificar resposta"
      );
    }
  }catch(e){    
    return ApiResponse(
      sucesso: false,
      mensagem: "Falha na conexão. Verifique sua internet ou a conexao com o servidor."
    );
  } 
}

Future<ApiResponse> alterarSenha() async{
  var urlCompleta = Uri.parse("$url$porta/usuarios/alterarsenha");   
  montaCheck();
  String ctr = box.read("ctr");
  String nome = box.read("login");

  Map<String, dynamic> req = {
    "ctr" :  ctr,
    "nome" : nome,
    "check" : usuario.check
  };

  try{
    var resposta =  await http.post(urlCompleta,headers: {'Content-Type': 'application/json'},body: jsonEncode(req));     
    try{
      var body = jsonDecode(resposta.body);
      ApiResponse resp = ApiResponse.fromMap(body);
      if (resposta.statusCode == 200) {
        return ApiResponse(sucesso: true, mensagem: resp.mensagem);
      }else {
        return ApiResponse(sucesso: false, mensagem: resp.mensagem);
      }
    }catch(e){
      return ApiResponse(
        sucesso: false,
        mensagem: "Falha ao descodificar resposta."
      );
    }
  }catch(e){    
    return ApiResponse(
      sucesso: false,
      mensagem: "Falha na conexão. Verifique sua internet ou a conexao com o servidor."
    );
  } 
}


obtemDados(){
    String ctr = box.read("ctr");
    String nome = box.read("login");
    setCampo("nome", nome);
    setCampo("ctr", ctr);
    ctrController.text = ctr;
    nomeController.text = nome;
    
}
