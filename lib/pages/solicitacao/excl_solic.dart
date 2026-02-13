import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/pages/solicitacao/page_exclusao.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';

import '../../store/arquivos_mob.dart';

class Exclusaosolic extends StatefulWidget {
  const Exclusaosolic({super.key});
  

  @override
  State<Exclusaosolic> createState() => _ExclusaosolicState();
  
}

class _ExclusaosolicState extends State<Exclusaosolic> {
  var solic = Get.find<ArquivosMob>(); 

  @override
  void initState() {    
    super.initState();
    Future.delayed(Duration(milliseconds: 300), ()async {
     await solic.obtemSolic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size; 
    return Scaffold(
      appBar: CustomAppBar(title: "Exclusao de  Solicitacoes"),
      drawer: CustomDrawer(),
      body: Observer(
        builder: (context) {
          return Column(
            children: [              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(            
                  child: SizedBox (
                    height: screenSize.height*0.9,
                    child: Expanded(
                      child: Observer(
                        builder: (context) {
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10), // Padding lateral na lista
                            itemCount: solic.listaAlt.length,
                            itemBuilder: (contextList, index) {
                              final solicitacao = solic.listaAlt[index];
                                return Column(
                                          children: [
                                            Card(                                                                                                                                                                             
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: ListTile(                                                                                                        
                                                  title: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                           Expanded(
                                                            flex: 1,
                                                            child: ElevatedButton(
                                                              onPressed: () async{
                                                                await solic.montaAnexos(solicitacao);
                                                                Get.to(() => Pageexclusao(solicitacao: solicitacao));
                                                              }, 
                                                              child: const Icon(Icons.delete, color: Colors.white),
                                                            )
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CustomTextfield( 
                                                             label: "Cod",
                                                             enabled: false,
                                                              controller:TextEditingController(text: '${solicitacao.cod}'),                                  
                                                            )
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            flex: 6,
                                                            child: CustomTextfield( 
                                                              label:  'Solicitante  ',
                                                              enabled: false,
                                                              controller:TextEditingController(text: '${solicitacao.solicitante}'),                                    
                                                            )
                                                          ),                                                                                                                                                    
                                                          SizedBox(width: 10),                                                     
                                                          Expanded(
                                                            flex: 2,
                                                              child: CustomTextfield(                                       
                                                                label:  'Prioridade',                                      
                                                                enabled: false,
                                                                controller: TextEditingController(text: '${solicitacao.prioridade}'),                                      
                                                              )
                                                            ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            flex: 2,
                                                            child: CustomTextfield(
                                                              label: 'Data Inclusao', 
                                                              enabled: false,
                                                              controller: TextEditingController(text: '${solicitacao.dataEmissao}'),                                    
                                                            )
                                                          ),                                                     
                                                          SizedBox(width: 10),                                                                                      
                                                          Expanded(
                                                            flex: 2,
                                                            child: CustomTextfield(
                                                              label: 'Status', 
                                                              enabled: false,
                                                              controller: TextEditingController(text: '${solicitacao.status}'),                                    
                                                            )
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),            
                                                ),
                                              ),                                                    
                                            ),
                                          ],
                                        );
                                      }
                                    );
                        }
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}