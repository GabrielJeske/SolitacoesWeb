import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/controller/arq.dart';
import 'package:solicitacoes/funcoes/date.dart';
import 'package:solicitacoes/funcoes/solic_net.dart';
import 'package:solicitacoes/objetos/solicitacoes.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';
import 'package:solicitacoes/widgets/anexo.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';


class PageConcluiSolic extends StatefulWidget {
  final Solicitacoes solicitacao;
  
  const PageConcluiSolic({super.key, required this.solicitacao});


  @override
  State<PageConcluiSolic> createState() => _PageConcluiSolicState();
}

class _PageConcluiSolicState extends State<PageConcluiSolic> {
  late TextEditingController codController;
  late TextEditingController dataController;
  late TextEditingController ctrController;
  late TextEditingController solicitanteController;
  late TextEditingController descricaoController; 
  final TextEditingController solucaoController = TextEditingController();
  final TextEditingController dataConclusaoController = TextEditingController();
  final TextEditingController aceitouController = TextEditingController();
  final TextEditingController versaoController = TextEditingController();
  final TextEditingController tecnicoController = TextEditingController();  
  final arq = Get.find<ArquivosMob>();  

  @override
  void initState() {  
    super.initState();
    codController = TextEditingController(text: widget.solicitacao.cod);
    cod.text = widget.solicitacao.cod ?? "";
    dataController = TextEditingController(text: widget.solicitacao.dataEmissao);
    solicitanteController = TextEditingController(text: widget.solicitacao.solicitante);
    ctrController = TextEditingController(text: widget.solicitacao.ctr);
    data.text = widget.solicitacao.dataEmissao ?? "";
    descricaoController = TextEditingController(text: widget.solicitacao.descricao);
    descricao.text = widget.solicitacao.descricao ?? "";
    dataConclusaoController.text = Data.getData;
    setCampo('prioridade',widget.solicitacao.prioridade);
    setCampo('status',widget.solicitacao.status);
  }

  @override
  void dispose() {
    // 3. Descarte-os quando o widget for removido
    codController.dispose();
    dataController.dispose();
    descricaoController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: "Central de Solicitacao"),
      body: Observer(
        builder: (context) {
          return SingleChildScrollView(
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [                                        
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              enabled: false,
                              label: 'Cod',
                              controller: codController
                            ),                    
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              label: 'Data Emissao',
                              enabled: false,
                              controller: dataController,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              label: 'CTR',
                              enabled: false,
                              controller: ctrController,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              label: 'Solicitante',
                              enabled: false,
                              controller: solicitanteController,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              label: 'Prioridade',
                              enabled: false,
                              controller: TextEditingController(text: widget.solicitacao.prioridade),
                            ),
                          ),                                              
                        ],
                      ),                    
                      SizedBox(height: 20),                                                            
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfield(
                              label: 'Descricao',
                              enabled: false,
                             // maxLines: 20,
                              controller: descricaoController,
                              onChanged: (value){
                                setCampo('descricao', value);
                              },
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 20), 
                      Row(
                        children: [
                           Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              enabled: false,
                              label: 'Conclusao',
                              controller: dataConclusaoController
                            ),                    
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              label: 'Aceitou',                              
                              controller: aceitouController,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              label: 'Versao',                              
                              controller: versaoController,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: CustomTextfield(
                              label: 'Quem Atualizou',                              
                              controller: tecnicoController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20), 
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfield(
                              label: 'Solução',
                              // enabled: false,
                              maxLines: 20,
                              controller: solucaoController,
                              onChanged: (value){
                                setCampo('solucao', value);
                              },
                            )
                            ),
                          ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Anexos Solicitante:")
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [                  
                          Expanded(
                            child: SizedBox(
                            height: 60, // A altura deve ser suficiente para o teu item.
                            child: Observer(
                              builder: (context) {
                                return ListView.builder(
                                  // Usa a lista local
                                  itemCount: arq.anexos.length, 
                                  // Garante a horizontalidade
                                  scrollDirection: Axis.horizontal, 
                                  // Garante que o ListView não ocupa mais espaço do que o necessário
                                  shrinkWrap: true, 
                                  itemBuilder: (contextList, index) { 
                                    final anexo = arq.anexos[index];
                                    // NOVO: Usa um Widget mais visual (como o _AnexoItem do exemplo anterior)
                                    return AnexoItem(
                                      nome: anexo.name,
                                      onRemove:   () => {},
                                    );
                                  }
                                );
                              }
                            ),
                                                  ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),          
                      Row(
                        children: [
                          Text("Anexos Desenvolvedor:")
                        ],
                      ),
                      SizedBox(height: 20),                           
                      Row(
                        children: [                  
                          Expanded(
                            child: SizedBox(
                            height: 60, // A altura deve ser suficiente para o teu item.
                            child: Observer(
                              builder: (context) {
                                return ListView.builder(
                                  // Usa a lista local
                                  itemCount: arq.anexosSpeed.length, 
                                  // Garante a horizontalidade
                                  scrollDirection: Axis.horizontal, 
                                  // Garante que o ListView não ocupa mais espaço do que o necessário
                                  shrinkWrap: true, 
                                  itemBuilder: (contextList, index) { 
                                    final anexoSpeed = arq.anexosSpeed[index];
                                    // NOVO: Usa um Widget mais visual (como o _AnexoItem do exemplo anterior)
                                    return AnexoItem(
                                      nome: anexoSpeed.name,
                                      onRemove: () => arq.removerAnexoSpeed(index),
                                    );
                                  }
                                );
                              }
                            ),
                                                  ),
                          ),
                        ],
                      ),                      
                      SizedBox(height: 20),
                        Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async{ 
                              await altSolic();
                              Get.snackbar("Sucesso", "Solicitacao enviada!");
                              await resetSolic();
                            }, 
                            child: Text('Concluir')
                          ),    
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {                
                              arq.baixaAnexoSpeed();
                            },
                            child: const Icon(Icons.drive_folder_upload_outlined, color: Colors.white),
                          ),                      
                        ],
                      ),
                    ],
                  ),
                ),
            ),
          );
        }
      ),
    );
  }
}