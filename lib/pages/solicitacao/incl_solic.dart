import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/controller/arq.dart';
import 'package:solicitacoes/funcoes/date.dart';
import 'package:solicitacoes/funcoes/solic_net.dart';
import 'package:solicitacoes/funcoes/uteis.dart';
import 'package:solicitacoes/funcoes/visualizador_bytes.dart';
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
    Future.delayed(const Duration(milliseconds: 300), () async {
      Uteis.openDialog();
      ApiResponse resp = await obtemCod();
      Uteis.closeDialog();     
      if (resp.sucesso){        
        cod.text = resp.data["proxCod"];        
      }else{   
        Uteis.showSnack(titulo: "Atenção", mensagem: resp.mensagem);        
      }
      
      data.text = Data.getData;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Inclusão de Solicitação'),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
          elevation: 4,
          //
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Título do Card ---
                Text(
                  "Nova Solicitação",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,                   
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(color: Colors.white10),
                ),
                
                // --- Linha 1: Cod, Data Emissão e Prioridade ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextfield(
                        label: 'Cód',
                        controller: cod,
                        enabled: false,
                      ),                    
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: CustomTextfield(
                        label: 'Data Emissão',
                        controller: data,
                        enabled: false,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: DropdownMenu<String>(                   
                        expandedInsets: EdgeInsets.zero, // Faz ocupar o espaço do Expanded
                        initialSelection: prio.first,   
                        label: const Text("Prioridade"),
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white24, width: 1),
                          ),
                        ),      
                        dropdownMenuEntries: prio.map<DropdownMenuEntry<String>>(
                          (String value) {
                            Color corDoTexto = Theme.of(context).colorScheme.onSurface;                    
                            switch (value){
                              case 'Normal':
                                corDoTexto = Colors.green.shade400;
                              break;
                              case 'Importante':
                                corDoTexto = Colors.orange.shade400;
                              break;
                              case 'Urgente':
                                corDoTexto = Colors.red.shade400;       
                              break;
                            }
                            return DropdownMenuEntry<String>(
                              value: value, 
                              label: value,
                              style: MenuItemButton.styleFrom(
                                foregroundColor: corDoTexto, // Cor das opções na lista
                              )                            
                            );
                          }
                        ).toList(),
                        onSelected: (String? value){       
                          setField('prioridade', value);
                        }
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), 
                
                // --- Linha 2: Descrição ---                    
                CustomTextfield(
                  label: 'Descrição',
                  maxLines: 12, // Reduzi de 20 para 12 para ficar mais elegante
                  controller: descricao,
                  onChanged: (value){
                    setField('descricao', value);
                  },
                ),
                const SizedBox(height: 20),
                
                // --- Linha 3: Anexos ---
                Observer(
                  builder: (context) {
                    if (arq.anexos.isEmpty) return const SizedBox.shrink();
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Arquivos Anexados:",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 60, 
                          child: ListView.builder(
                            itemCount: arq.anexos.length, 
                            scrollDirection: Axis.horizontal, 
                            shrinkWrap: true, 
                            itemBuilder: (contextList, index) { 
                              final anexo = arq.anexos[index];
                              return InkWell(
                                onTap: () => VisualizadorBytes.abrir(anexo.name, anexo.bytes),
                                child: AnexoItem(
                                  nome: anexo.name,
                                  onRemove: () => arq.removerAnexo(index),
                                ),
                              );
                            }
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                ),
                
                const Divider(color: Colors.white10),
                const SizedBox(height: 10),
                
                // --- Linha 4: Botões de Ação Padronizados ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {                
                        arq.baixaAnexo();            
                      },
                      icon: const Icon(Icons.attach_file, size: 18),
                      label: const Text("Anexar Arquivo"),                      
                    ),  
                    const SizedBox(width: 15),
                    ElevatedButton.icon(
                      onPressed: () async {   
                        Uteis.openDialog();
                        ApiResponse resp = await salvaSolic();   
                        Uteis.closeDialog();                    
                        if (resp.sucesso) {                                                   
                          await resetSolic();
                          Uteis.showSnack(titulo: "Sucesso!", mensagem: resp.mensagem);                          
                        } else {                                                    
                          Uteis.showSnack(titulo: "Falha!", mensagem: resp.mensagem);
                        }                           
                      },               
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Salvar Solicitação',),                     
                    ),            
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}