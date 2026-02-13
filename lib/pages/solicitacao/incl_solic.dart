import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/controller/arq.dart';
import 'package:solicitacoes/funcoes/date.dart';
import 'package:solicitacoes/funcoes/solic_net.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';
import 'package:solicitacoes/widgets/anexo.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';

class Inclusaosolicitacao extends StatefulWidget {
  const Inclusaosolicitacao({super.key});

  @override
  State<Inclusaosolicitacao> createState() => _InclusaosolicitacaoState();
}

class _InclusaosolicitacaoState extends State<Inclusaosolicitacao> {
  static List<String> prio = <String>['Normal', 'Importante', 'Urgente'];
  final arq = Get.find<ArquivosMob>();  

  @override
  void initState() {  
    super.initState();
    Future.delayed(Duration(milliseconds: 300), ()async {
      ApiResponse resp = await obtemCod();
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );     
      if (!resp.sucesso){
        cod.text = resp.data["proxCod"];
        Get.back();
      }else{
        Get.back();
        Get.snackbar(
          "Atencao", resp.mensagem
        );
      }      
      data.text= Data.getData;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Inclusao de Solicitacao'),
      drawer: CustomDrawer(),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [  
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomTextfield(
                      label: 'Cod',
                      controller: cod,
                      enabled: false,
                    ),                    
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: CustomTextfield(
                      label: 'Data Emissao',
                      controller: data,
                      enabled: false,
                    ),
                  ),
                  SizedBox(width: 20),
                  DropdownMenu<String>(                   
                    initialSelection: prio.first,                  
                    dropdownMenuEntries: prio.map<DropdownMenuEntry<String>>(
                      (String value){
                       Color corDoTexto = Colors.black;                    
                        switch (value){
                          case 'Normal':
                            corDoTexto = Colors.green.shade700;
                          break;
                          case 'Importante':
                            corDoTexto = Colors.orange.shade700;
                          break;
                          case 'Urgente':
                            corDoTexto = Colors.red.shade700;       
                          break;
                          default:
                            corDoTexto = Colors.black;
                          break;
                        }
                        return DropdownMenuEntry<String>(
                          value: value, 
                          label: value, // O que o utilizador vê no menu
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(corDoTexto),
                          )                            
                        );
                      }
                    ).toList(),
                    onSelected: (String? value){       
                      setCampo('prioridade', value);
                    }

                  ),
                  Spacer()
                ],
              ),
              SizedBox(height: 20),                     
              Row(
                children: [
                  Expanded(
                    child: CustomTextfield(
                      label: 'Descricao',
                      maxLines: 20,
                      controller: descricao,
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
                              onRemove: () => arq.removerAnexo(index),
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
                      await salvaSolic();
                      Get.snackbar("Sucesso", "Solicitacao enviada!");
                      await resetSolic();
                    }, 
                    child: Text('Salvar')
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {                
                      arq.baixaAnexo();            
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
}