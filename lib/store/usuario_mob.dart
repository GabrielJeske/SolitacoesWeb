import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:solicitacoes/controller/constantes.dart';
import 'package:solicitacoes/controller/usuarios.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/objetos/usuario.dart';

part 'usuario_mob.g.dart';

class UsuarioMob = UsuarioMobBase with _$UsuarioMob;

abstract class UsuarioMobBase with Store {

  @observable
  ObservableList<Usuario> usuarios = ObservableList<Usuario>();

  @observable
  bool alteracao = true;

  @observable
  ObservableList<String> acessos = ObservableList<String>();

  @observable
  ObservableList<bool> filtros = ObservableList<bool>();

  @observable
  ObservableMap<String, String?> formErrors = ObservableMap.of({});

  @observable
  String busca = '';

  @observable
  bool exibeListaUsuarios = false;

  @observable
  Usuario userSele = Usuario();

  @observable
  Usuario antigoUser = Usuario();

  @computed
  bool get isFormValid => formErrors.values.every((error) => error == null);

  @computed
  List<Usuario> get listaFiltrada {
    if (busca.isEmpty) {
      return usuarios.toList();
    } else {
      return usuarios.where((user) {
        String nome = user.nome?.toString().toLowerCase() ?? '';      
        bool listaFiltrada = nome.contains(busca.toLowerCase());
        return listaFiltrada;
      }).toList();
    }
  }

  @action
  void setAlt(bool value){
    alteracao = value;
  }
  
  @action
  Future<ApiResponse> obtemUsuarios() async{
    try {
      ApiResponse resp = await consultaUsuarios();
      if (resp.sucesso){
        List<dynamic> listaUsers = resp.data;
        List<Usuario> users = listaUsers.map((json) => Usuario.fromJson(json as Map<String, dynamic>)).toList();
        runInAction(() {
          usuarios.clear();
          usuarios.addAll(users);
        });
        return ApiResponse(sucesso: true, mensagem: "Sucesso ao obter Usuarios");
      }else{
        return ApiResponse(sucesso: false, mensagem: "Falha ao interar lista de Usuarios ${resp.mensagem}");
      }
    }catch (e) {
      return ApiResponse(sucesso: false, mensagem: "Falha ao ter resposta:");
    }
  }

  @action
  Future <ApiResponse> obtemListaAcessos() async{
    var urlCompleta = Uri.parse("$url$porta/acessos");         
    try{
      var resposta =  await http.get(urlCompleta,headers: {'Content-Type': 'application/json'}).timeout(timeOut);                    
      try{
        var body = jsonDecode(resposta.body);
        ApiResponse resp = ApiResponse.fromMap(body);  
       
        if (resposta.statusCode == 200 && resp.sucesso)  {
          List<String> listaAcessos = List<String>.from(resp.data);
          acessos.clear();
          acessos.addAll(listaAcessos.cast<String>());
          int totalFiltros =  acessos.length * 2;
          for (var i = 0; i < totalFiltros; i ++) {                 
            filtros.add(false);
          }  
          return ApiResponse(sucesso: true, mensagem: "Acessos carregados");
        } else {          
          return ApiResponse(sucesso: false, mensagem: "Erro ao obter resposta: ${resposta.statusCode}, Mensagem: ${resp.mensagem}" );
        }          
      }catch (e) {
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

  
  @action
  void setBusca(String termo){
    busca = termo;
  }

  @action
  void setFiltro(int chave, bool valor) {
    filtros[chave] = valor;
  }

   @action
  void setListaUsuarios(bool value) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    exibeListaUsuarios = value;
  }

  @action
  void resetFiltros (){
    for (var i = 0; i < filtros.length; i++) {
      filtros[i] = false;
    }
  }

  @action
  void selecUser(Usuario usuarioSelec) {  

    antigoUser = usuarioSelec; 
    userSele = usuarioSelec;
    resetUsuario();
        
    nomeController.text = userSele.nome ?? '';
    setCampo("nome", userSele.nome ?? '');
    senhaController.text = '***';
    setCampo("senha", "***");
    emailController.text = userSele.email ?? '';
    setCampo("email", userSele.email ?? '');
    numeroController.text = userSele.cel ?? '';
    setCampo("cel", userSele.cel ?? '');
    cargoController.text = userSele.cargo ?? '';
    setCampo("cargo", userSele.cargo ?? '');

    int limite = acessos.length;
    log("limite igual a $limite");

    for (var i = 0; i < limite; i ++) {   
      log("vai percorrer i = $i");
      int iIndice = i*2;
      log("setou o iIndice = $iIndice");
      int jIndice = iIndice + 2;  
      log("setou o jIndice = $jIndice");
      for (var j = iIndice; j < jIndice; j++) {         
        log("Vai checar de  ${userSele.permissoes![acessos[i]]} eh igual a proprio ou a geral");
        if (userSele.permissoes![acessos[i]] == "proprio"){   
          log("$j eh proprio");
          if(j.isEven){
            filtros[j] = true;   
          }
        }else if (userSele.permissoes![acessos[i]] == "geral"){
          log("$j eh geral");
           if(j.isOdd){
            filtros[j] = true;   
          }
        } else {
          log("$j eh false");
           filtros[j] = false;
        }               
        }
      }    
   }

}
