import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/pages/solicitacao/page_aceita_solic.dart';
import 'package:solicitacoes/pages/solicitacao/page_conclui_solic.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';

import '../../store/arquivos_mob.dart';

class Speedsolic extends StatefulWidget {
  const Speedsolic({super.key});
  

  @override
  State<Speedsolic> createState() => _SpeedsolicState();
  
}

class _SpeedsolicState extends State<Speedsolic> {
  var solic = Get.find<ArquivosMob>(); 
  Map<String, bool> filtros = {
    'Normal': false,
    'Importante': false,
    'Urgente': false,
    'Pendente': false,
    'Processando': false,
    'Concluído': false,
  };

  @override
  void initState() {    
    super.initState();
    Future.delayed(Duration(milliseconds: 300), ()async {
     await solic.obtemSolic();
    });
  }
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size; // Não é necessário para a altura nesta abordagem
    return Scaffold(
      appBar: CustomAppBar(title: "Central de Solicitacoes"),
      drawer: CustomDrawer(),
      body: Observer(
        builder: (context) {
          return Column(
            children: [
               Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(                 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      children: [                        
                        // const SizedBox(width: 15),
                        // Text(
                        //   'Status:', 
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     fontWeight: FontWeight.bold,
                        //     // Texto Branco
                        //     color: Theme.of(context).colorScheme.onSurface 
                        //   )
                        // ), 
                        // const SizedBox(width: 15),      
                        // Checkbox(
                        //   value: solic.filtros['Pendente'],                          
                        //   activeColor: Theme.of(context).colorScheme.primary, 
                        //   // Borda cinza clara para ver onde clicar no escuro
                        //   side: BorderSide(color: Colors.grey.shade500, width: 2),
                        //   onChanged: (bool? value) => solic.setFiltro('Pendente', value ?? false),     
                        // ),
                        // Text(
                        //   'Pendente', 
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     fontWeight: FontWeight.bold,
                        //     // Texto Branco
                        //     color: Theme.of(context).colorScheme.onSurface 
                        //   )
                        // ),                        
                        // const SizedBox(width: 10),                                  
                        // Checkbox(
                        //   value: solic.filtros['Em Andamento'],
                        //   activeColor: Theme.of(context).colorScheme.primary,
                        //   side: BorderSide(color: Colors.grey.shade500, width: 2),
                        //   onChanged: (bool? value) => solic.setFiltro('Em Andamento', value ?? false),       
                        // ),
                        // Text(
                        //   'Em Andamento', 
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     fontWeight: FontWeight.bold,
                        //     color: Theme.of(context).colorScheme.onSurface
                        //   )
                        // ),
          
                        // const SizedBox(width: 10),                        
                        // Checkbox(
                        //   value: solic.filtros['Concluido'],
                        //   activeColor: Theme.of(context).colorScheme.primary,
                        //   side: BorderSide(color: Colors.grey.shade500, width: 2),
                        //   onChanged: (bool? value) => solic.setFiltro('Concluido', value ?? false),      
                        // ),
                        // Text(
                        //   'Concluido', 
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     fontWeight: FontWeight.bold,
                        //     color: Theme.of(context).colorScheme.onSurface
                        //   )
                        // ),
                        // const SizedBox(width: 30),
                        // Text(
                        //   'Prioridade:', 
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     fontWeight: FontWeight.bold,
                        //     // Texto Branco
                        //     color: Theme.of(context).colorScheme.onSurface 
                        //   )
                        // ),
                        // const SizedBox(width: 15),       
                        // Checkbox(
                        //   value: solic.filtros['Urgente'],                          
                        //   activeColor: Theme.of(context).colorScheme.primary, 
                        //   // Borda cinza clara para ver onde clicar no escuro
                        //   side: BorderSide(color: Colors.grey.shade500, width: 2),
                        //   onChanged: (bool? value) => solic.setFiltro('Urgente', value ?? false),     
                        // ),
                        // Text(
                        //   'Urgente', 
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     fontWeight: FontWeight.bold,
                        //     // Texto Branco
                        //     color: Theme.of(context).colorScheme.onSurface 
                        //   )
                        // ),                        
                        // const SizedBox(width: 10),                                  
                        // Checkbox(
                        //   value: solic.filtros['Importante'],
                        //   activeColor: Theme.of(context).colorScheme.primary,
                        //   side: BorderSide(color: Colors.grey.shade500, width: 2),
                        //   onChanged: (bool? value) => solic.setFiltro('Importante', value ?? false),       
                        // ),
                        // Text(
                        //   'Importante', 
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     fontWeight: FontWeight.bold,
                        //     color: Theme.of(context).colorScheme.onSurface
                        //   )
                        // ),
          
                        // const SizedBox(width: 10),                        
                        // Checkbox(
                        //   value: solic.filtros['Normal'],
                        //   activeColor: Theme.of(context).colorScheme.primary,
                        //   side: BorderSide(color: Colors.grey.shade500, width: 2),
                        //   onChanged: (bool? value) => solic.setFiltro('Normal', value ?? false),      
                        // ),
                        // Text(
                        //   'Normal', 
                        //   style: TextStyle(
                        //     fontSize: 12, 
                        //     fontWeight: FontWeight.bold,
                        //     color: Theme.of(context).colorScheme.onSurface
                        //   )
                        // ),
                        // const SizedBox(width: 10),  

                        // const Spacer()
                      ],
                    ),
                  ),
                ),
              ),
                //2
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: screenSize.height*0.8,
                    child: Expanded(
                      child: Observer(
                        builder: (context) {
                          return ListView.builder( 
                            itemCount: solic.listaAlt.length,
                            itemBuilder: (contextList, index) {
                              final solicitacao = solic.listaAlt[index];
                              Color statusColor;
                                switch (solicitacao.status?.toLowerCase()) {
                                  case 'pendentes':
                                    statusColor = Colors.yellow
                                    .shade400; // Laranja neon
                                    break;
                                  case 'concluido':
                                    statusColor = Colors.green;
                                    break;
                                  default:
                                    statusColor = Colors.blue; // Azul do logo
                                }
                              return Card(   
                                // color:statusColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  
                                  // side: BorderSide(color: statusColor, width: 1),
                                ),
                                
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
                                                if (solicitacao.status == 'pendentes'){                                                 
                                                  Get.to(() => PageAceitaSolic(solicitacao: solicitacao));
                                                  return;
                                                }else if (solicitacao.status == 'Em andamento'){                                                  
                                                  Get.to(() => PageConcluiSolic(solicitacao: solicitacao));
                                                  return;
                                                }else if (solicitacao.status == 'concluido'){                                                  
                                                  // Get.to(() => ConsSolicConcluida(solicitacao: solicitacao));
                                                  return;
                                                }
                                              }, 
                                              child: const Icon(Icons.check, color: Colors.white),
                                            )
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Icon(Icons.circle, color: statusColor, size: 30,) 
                                            ),                                                                                      
                                          Expanded(
                                            flex: 2,
                                            child: CustomTextfield( 
                                             label: "Cod",
                                              controller:TextEditingController(text: '${solicitacao.ctr}${solicitacao.cod}'),                                  
                                            )
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 6,
                                            child: CustomTextfield( 
                                              label:  'Solicitante  ',
                                              controller:TextEditingController(text: '${solicitacao.solicitante}'),                                    
                                            )
                                          ),                                                                                                                                    
                                          SizedBox(width: 10),                                     
                                          Expanded(
                                            flex: 2,
                                              child: CustomTextfield(                                       
                                                label:  'Prioridade',                                      
                                                controller: TextEditingController(text: '${solicitacao.prioridade}'),                                      
                                              )
                                            ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 2,
                                            child: CustomTextfield(
                                              label: 'Data Inclusao', 
                                              controller: TextEditingController(text: '${solicitacao.dataEmissao}'),                                    
                                            )
                                          ),
                                     
                                      SizedBox(width: 10),                            
                                          Expanded(
                                            flex: 2,
                                              child: CustomTextfield(                                       
                                                label:  'Data de Processamento',                                      
                                                controller: TextEditingController(text: '${solicitacao.dataAceito}'),
                                              )
                                            ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 2,
                                            child: CustomTextfield(                                              
                                              label: 'Status', 
                                              controller: TextEditingController(text: '${solicitacao.status}'),                                    
                                            )
                                          ),                                                                                    
                                        ],
                                      )
                                    ],
                                  ),            
                                ),                                                    
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