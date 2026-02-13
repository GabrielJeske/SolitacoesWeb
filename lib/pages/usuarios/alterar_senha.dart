

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/controller/usuarios.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/store/usuario_mob.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/widgets/custom_buttom.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';

class AlterarSenha extends StatefulWidget {
  const AlterarSenha({super.key});

  @override
  State<AlterarSenha> createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  final UsuarioMob usuarioMob = Get.find<UsuarioMob>();

  @override
  void initState() {
    resetUsuario();
    obtemDados();
    super.initState();
  }

  @override
  void dispose() {
    resetUsuario();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Alterar Senha'),
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
                          flex: 2,      
                          child: CustomTextfield(
                            label: 'CTR',
                            controller: ctrController,                                                        
                            enabled: false,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(       
                          flex: 7,                   
                          child: CustomTextfield(
                            label: 'Nome',
                            controller: nomeController,                            
                            enabled: false,                                                                                  
                          ),
                        ),                        
                      ],
                    ),                  
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(                          
                          child: CustomTextfield(
                            label: 'Nova Senha',
                            obscureText: true,    
                            errorText: usuarioMob.formErrors["senha"],                            
                            controller: senhaController,
                            onChanged: (value) {
                              setCampo("senha", value);
                            },
                          ),
                        ),
                      ]  
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButtom(onPressed: resetUsuario, label: 'Cancelar'),
                        SizedBox(width: 10),
                        CustomButtom(
                          onPressed: () async {
                            validaSenha();
                            if (usuarioMob.formErrors.values.every((error) => error == null)) {
                              Get.dialog(
                                const Center(child: CircularProgressIndicator()),
                                barrierDismissible: false,
                              );  

                              ApiResponse resp = await alterarSenha();

                              if (resp.sucesso) {
                                Get.back();
                                resetUsuario();
                                Get.snackbar(
                                  'Sucesso',
                                  resp.mensagem,
                                );
                                Get.toNamed("/login");
                              } else {
                                Get.back();
                                Get.snackbar(
                                  'Falha',
                                  resp.mensagem,
                                );
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
        ),
      ),
    );
  }
}
