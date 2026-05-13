import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/funcoes/login.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/widgets/custom_buttom.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';

import '../store/login_mob.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   final LoginMob loginMob = Get.find<LoginMob>();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(      
      appBar: CustomAppBar(title: 'Login'),
      body: Padding(
        padding: EdgeInsets.all(100),
        child: Observer(
          builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        label: 'CTR',
                        errorText: loginMob.formErrors["ctr"],
                        onChanged: (value){
                          setCampo('ctr', value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), 
                Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        label: 'Login',
                        errorText: loginMob.formErrors["login"],
                        onChanged: (value){                   
                          setCampo('login', value);
                        },
                      ),
                    ),
                  ],
                ),          
                const SizedBox(height: 20), 
                Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        obscureText: true,
                        label: 'Senha',
                        errorText: loginMob.formErrors["senha"],
                        onChanged: (value){
                          setCampo('senha', value);
                        },                    
                        ),
                    )
                  ],
                ),
                SizedBox(height: 30,),                      
                Row(
                  children: [
                    Expanded(
                      child:                             
                CustomButtom(
                  onPressed: () async {   
                    validaTodosCampos();
                    if (loginMob.isFormValid){
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );                         

                      ApiResponse respLogin = await fazLogin();                     
                      
                      if (respLogin.sucesso){           
                        
                        ApiResponse respAcessos = await obtemPermissoesUser();
                        
                        if (respAcessos.sucesso){
                          Get.back();
                          resetLogin();                                                                       
                          Get.toNamed("/"); 
                        }else{
                          Get.back();
                          Get.snackbar(                            
                            'Atenção', 
                            'Login realizado, mas houve erro ao carregar permissões: ${respAcessos.mensagem}',                           
                          );
                        }                                            
                      }else{    
                        Get.back();                    
                       Get.snackbar(
                          'Erro no Login', 
                          respLogin.mensagem,      
                        );
                      }
                    }else{
                      Get.snackbar('Login', 'Preencha os campos corretamente');
                    }                                                         
                  },
                  label: 'Entrar',
                ),
              ),
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