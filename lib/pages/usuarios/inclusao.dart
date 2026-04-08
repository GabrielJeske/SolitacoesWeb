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

class Inclusao extends StatefulWidget {
  const Inclusao({super.key});

  @override
  State<Inclusao> createState() => _InclusaoState();
}

class _InclusaoState extends State<Inclusao> {
  final UsuarioMob usuarioMob = Get.find<UsuarioMob>();

  @override
  void initState() {    
     resetUsuario();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      Uteis.openDialog();
      ApiResponse resp =  await usuarioMob.obtemListaAcessos();  
      Uteis.closeDialog();

      if (!resp.sucesso){                      
        Uteis.showSnack(titulo: "Falha", mensagem: resp.mensagem);
      }
    });
    super.initState();    
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      resetUsuario();
      
    });
    super.dispose();    
  }

  @override
  Widget build(BuildContext context) {
  final Size screenSize = MediaQuery.of(context).size; 
    return Scaffold(
      appBar: CustomAppBar(title: 'Inclusao de Usuário'),
      drawer: CustomDrawer(),
      body: CustomForm(
        child: Observer(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (isSpeed())
                    Expanded(
                      flex: 3,
                      child: CustomTextfield(
                        label: 'Ctr',
                        controller:ctrController,
                        enabled: isSpeed(), 
                        errorText: isSpeed() ? usuarioMob.formErrors["ctr"] : null,
                        onChanged: (value) {
                           setCampo("ctr", value);
                        },
                      ),
                    ),
                    if (isSpeed())
                    SizedBox(width: 20),
                    Expanded(
                      flex: 7,        
                      child: CustomTextfield(
                        label: 'Nome',
                        controller: nomeController,
                        enabled: true,
                        errorText: usuarioMob.formErrors["nome"],
                        onChanged: (value) {
                          setCampo("nome", value);
                        },
                      ),
                    ),
                  ],
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
                        errorText: usuarioMob.formErrors["email"],
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
                        mask: maskCel,
                        label: 'WhatsApp',
                        errorText: usuarioMob.formErrors["cel"],
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
                        errorText: usuarioMob.formErrors["cargo"],
                        onChanged: (value) {
                          setCampo("cargo", value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
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
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtom(onPressed: resetUsuario, label: 'Cancelar'),
                    SizedBox(width: 10),
                    CustomButtom(
                      onPressed: () async {
                        validaTodosCampos();
                        if (usuarioMob.isFormValid) {
                          Uteis.openDialog();
                          ApiResponse resp = await incluirUsuario();
                          Uteis.closeDialog();
                          log("Obteve a resposta ${resp.sucesso}");
                          if (resp.sucesso) {                                
                            resetUsuario();
                            Uteis.showSnack(titulo: "Sucesso!", mensagem: resp.mensagem);
                          } else {                                
                            Uteis.showSnack(titulo: "Falha!", mensagem: resp.mensagem);
                          }                             
                        } else {
                          Get.back();
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
          }
        ),
      ),
    );
  }
}
