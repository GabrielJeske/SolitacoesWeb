import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/controller/mascaras.dart';
import 'package:solicitacoes/controller/usuarios.dart';
import 'package:solicitacoes/funcoes/uteis.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/store/usuario_mob.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/widgets/custom_buttom.dart';
import 'package:solicitacoes/widgets/custom_form.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';

class Alteracao extends StatefulWidget {
  const Alteracao({super.key});

  @override
  State<Alteracao> createState() => _AlteracaoState();
}

class _AlteracaoState extends State<Alteracao> {
  final UsuarioMob usuarioMob = Get.find<UsuarioMob>();
  final FocusNode foco = FocusNode();  

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      resetUsuario();
      usuarioMob.setAlt(true);
      Uteis.openDialog();  

      ApiResponse resp =  await usuarioMob.obtemListaAcessos();   
      ApiResponse respU = await usuarioMob.obtemUsuarios();      

      Uteis.closeDialog();      

      if (!resp.sucesso){
        Uteis.showSnack(titulo: "Falha!", mensagem: resp.mensagem);
      }         
      
      if (!respU.sucesso){
        Uteis.showSnack(titulo: "Falha!", mensagem: resp.mensagem);
      }      
      foco.addListener(() {
         Future.delayed(Duration(milliseconds: 300), () {
          usuarioMob.setListaUsuarios(foco.hasFocus);
        });        
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usuarioMob.setAlt(true);
      resetUsuario();
    });
    super.dispose();
    foco.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size; 
    return Scaffold(
      appBar: CustomAppBar(title: 'Alteracao de Usuário'),
      drawer: CustomDrawer(),
      body: CustomForm(
        child: Observer(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [                                                
                    Expanded(                          
                      child: CustomTextfield(
                        label: 'Nome',
                        controller: nomeController,
                        errorText: usuarioMob.formErrors["nome"],
                        enabled: true,
                        onChanged: (value){                             
                          setCampo("nome", value);                            
                          usuarioMob.setBusca(value);                        
                        },
                        foco: foco,
                         onTap: () {
                          if (usuarioMob.alteracao){
                            resetUsuario();
                          }                          
                              
                        },                           
                      ),
                    ),
                  ],
                ),
                Observer(
                  builder: (__) {
                    if (usuarioMob.exibeListaUsuarios && usuarioMob.alteracao) {
                      return Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: usuarioMob.listaFiltrada.length,
                          itemBuilder: (contextList, index) {
                            final usuario =
                                usuarioMob.listaFiltrada[index];
                            return ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      usuario.nome ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        height: 1.40,
                                        letterSpacing: 0.06,
                                      ),
                                    ),
                                  ),                                      
                                ],                                  
                              ),                                                                    
                              onTap: () {                                    
                                usuarioMob.selecUser(usuario);
                                usuarioMob.setListaUsuarios(false);
                               usuarioMob.setAlt(false);
                                // foco.unfocus();
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomTextfield(
                        label: 'Senha',
                        obscureText: true,    
                        errorText: usuarioMob.formErrors["senha"],
                        enabled: !usuarioMob.alteracao,                        
                        controller: senhaController,
                        onChanged: (value) {
                          setCampo("senha", value);
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: CustomTextfield(
                        label: 'Email',                            
                        controller: emailController,
                        errorText: usuarioMob.formErrors["email"],
                        enabled: !usuarioMob.alteracao,
                        onChanged: (value) {
                          setCampo("email", value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        label: 'WhatsApp',
                        enabled: !usuarioMob.alteracao,
                        errorText: usuarioMob.formErrors["cel"],
                        mask: maskCel,
                        controller: numeroController,                            
                        onChanged: (value) {
                          setCampo("cel", value);
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CustomTextfield(
                        label: 'Cargo',
                        controller: cargoController,
                        enabled: !usuarioMob.alteracao,
                        errorText: usuarioMob.formErrors["cargo"],
                        onChanged: (value) {
                          setCampo("cargo", value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Observer(
                  builder: (context) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 4, child: Text('Acessos')),
                            SizedBox(height: 30),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Proprio',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Geral',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                         Observer(
                      builder: (context) {
                        return Container(
                        constraints: BoxConstraints(maxHeight: screenSize.height * 0.8 ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: usuarioMob.acessos.length,
                          itemBuilder: (contextList, index) {
                            final acesso =
                            usuarioMob.acessos[index];
                            int filtro1 = ( index * 2);
                            int filtro2 = filtro1 +1;
                            return ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Observer(
                                builder: (context){
                                  return Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(acesso),                                       
                                      ),
                                      SizedBox(height: 30),
                                      Expanded(
                                        flex: 2,
                                        child: Checkbox(
                                          value: usuarioMob.filtros[filtro1],
                                          onChanged: (value) {
                                            usuarioMob.setFiltro(filtro1, value!);
                                            log("Vai setar o $filtro1 e o index é $index");
                                            if (usuarioMob.filtros[filtro2]) {
                                              usuarioMob.setFiltro(filtro2, !value);
                                              log("Vai setar o $filtro2 e o index é $index");
                                            }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Checkbox(
                                          value: usuarioMob.filtros[filtro2],
                                          onChanged: (value) {
                                            usuarioMob.setFiltro(filtro2, value!);
                                            log("Vai setar o $filtro2 e o index é $index");
                                            if (usuarioMob.filtros[filtro1]) {
                                              usuarioMob.setFiltro(filtro1, !value);
                                              log("Vai setar o $filtro1 e o index é $index");
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              )                                                                                                     
                            );
                          },
                        ),
                                                  );
                      }
                    )
                      ],
                    );
                  },
                ),
                 SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtom(
                      onPressed: (){                            
                        resetUsuario();
                        usuarioMob.setAlt(true);
                      },
                      label: 'Cancelar'
                    ),
                    SizedBox(width: 10),
                    CustomButtom(
                      onPressed: () async {
                        validaAlteracao();
                        if (usuarioMob.isFormValid) {
                          Uteis.openDialog();
                          ApiResponse resp = await alterarUsuario();
                          Uteis.closeDialog();
                          if (resp.sucesso) {                                
                            resetUsuario();
                            usuarioMob.setAlt(true);
                            Uteis.showSnack(titulo: "Sucesso!", mensagem: resp.mensagem);                                
                          } else {
                            Uteis.showSnack(titulo: "Falha!", mensagem: resp.mensagem);
                          }                              
                        } else {
                          Get.snackbar('Falha', 'Prencha os dados!');
                        }
                      },
                      label: 'Salvar',
                    ),
                    SizedBox(width: 10),
                  ],
                ),                                        
              ],
            );
          },
        ),
      ),
    );
  }
}
