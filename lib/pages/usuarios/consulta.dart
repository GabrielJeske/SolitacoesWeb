import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/controller/usuarios.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/store/usuario_mob.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';

class Consulta extends StatefulWidget {
  const Consulta({super.key});

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  final UsuarioMob usuarioMob = Get.find<UsuarioMob>();

  final FocusNode foco = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      resetUsuario();
       ApiResponse resp =  await usuarioMob.obtemListaAcessos();   
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );     
      if (resp.sucesso){
        Get.back();
      }else{
        Get.back();
        Get.snackbar(
          "Atencao", resp.mensagem
        );
      }
      ApiResponse respU = await usuarioMob.obtemUsuarios();
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );     
      if (!respU.sucesso){
        Get.back();
      }else{
        Get.back();
        Get.snackbar(
          "Atencao", respU.mensagem
        );
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
      resetUsuario();
    });
    super.dispose();
    foco.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size; 
    return Scaffold(
      appBar: CustomAppBar(title: 'Consulta de Usuário'),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                            enabled: true,
                            foco: foco,
                             onTap: () {
                              resetUsuario();
                            },                           
                          ),
                        ),
                      ],
                    ),
                    Observer(
                      builder: (__) {
                        if (usuarioMob.exibeListaUsuarios) {
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
                            enabled: false,
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
                            enabled: false,
                            controller: emailController,
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
                            controller: numeroController,
                            enabled: false,
                            onChanged: (value) {
                              setCampo("cel", value);
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: CustomTextfield(
                            label: 'Cargo',
                            enabled: false,
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
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
