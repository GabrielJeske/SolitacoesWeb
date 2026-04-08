import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/funcoes/solic_net.dart';
import 'package:solicitacoes/funcoes/uteis.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/objetos/solicitacoes.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';

class CentralSolic extends StatefulWidget {
  const CentralSolic({super.key});

  @override
  State<CentralSolic> createState() => _CentralSolicState();
}

class _CentralSolicState extends State<CentralSolic> {
  final ArquivosMob solic = Get.find<ArquivosMob>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      solic.resetCampos();            
      Uteis.openDialog();
      ApiResponse resp = await solic.obtemSolic();
      Uteis.closeDialog();
      
      if (!resp.sucesso) {                           
        Uteis.showSnack(titulo: "Falha!", mensagem: resp.mensagem);
      }                
    });
  }

  @override
  void dispose() {
    solic.resetCampos();
    super.dispose();
  }

  // --- FUNÇÕES AUXILIARES DE UI ---

  // Constrói os botões de filtro (FilterChip) modernos
  Widget _buildFilterChip(String label, Color activeColor) {
    return Observer(
      builder: (_) {
        final isSelected = solic.filtros[label] ?? false;
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (bool value) => solic.setFiltro(label, value),         
          checkmarkColor: activeColor,
          labelStyle: TextStyle(
            color: isSelected ? activeColor : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),          
          side: BorderSide(
            color: isSelected ? activeColor : Theme.of(context).colorScheme.onSurface,
          ),
        );
      }
    );
  }

  // Identifica a cor do status
  Color _obterCorStatus(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s == 'concluido' || s == 'concluído') return Colors.green;
    if (s == 'pendente') return Colors.orange;
    if (s == 'desenvolvimento') return Colors.blue;
    if (s == 'recusada') return Colors.red;
    return Colors.grey;
  }

  // Identifica a cor da prioridade
  Color _obterCorPrioridade(String? prioridade) {
    final p = (prioridade ?? '').toLowerCase();
    if (p == 'urgente') return Colors.redAccent;
    if (p == 'importante') return Colors.orangeAccent;
    if (p == 'normal') return Colors.greenAccent;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Central de Solicitações"),
      drawer: const CustomDrawer(),
      body: Column(
        children: [        
          Container(
            padding: const EdgeInsets.all(16.0),            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Busca
                SearchBar(
                  hintText: "Buscar solicitação... ",
                  leading: const Icon(Icons.search),
                  //backgroundColor: WidgetStateProperty.all(Colors.grey.shade900),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
                  onChanged: (value) => solic.setTermoBusca(value),
                ),
                const SizedBox(height: 16),                              
                Wrap(
                  spacing: 12.0,
                  runSpacing: 10.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.filter_list, size: 20),
                    const Text("Status:", style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildFilterChip('Pendente', Colors.orange),
                    _buildFilterChip('Desenvolvimento', Colors.blue),
                    _buildFilterChip('Concluido', Colors.green),
                    
                    const SizedBox(width: 20), // Separador visual
                    
                    const Text("Prioridade:", style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildFilterChip('Urgente', Colors.redAccent),
                    _buildFilterChip('Importante', Colors.orangeAccent),
                    _buildFilterChip('Normal', Colors.greenAccent),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),

          // =========================================================
          // LISTA DE SOLICITAÇÕES
          // =========================================================
          Expanded(
            child: Observer(
              builder: (_) {
                if (solic.listaFiltrada.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        "Nenhuma solicitação encontrada",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: solic.listaFiltrada.length,
                  itemBuilder: (context, index) {
                    final item = solic.listaFiltrada[index];
                    final corStatus = _obterCorStatus(item.status);
                    final corPrio = _obterCorPrioridade(item.prioridade);
                                
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(width: 1),
                      ),
                      // InkWell para efeito de clique
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          Uteis.openDialog();
                          var resp = await obtemSolic(item.ctr ?? "00000", item.cod ?? "00000");                        
                           Uteis.closeDialog();
                          if (resp.sucesso) {                                                                                                                       
                            Solicitacoes solicitacaoObjeto = Solicitacoes.fromJson(resp.data);  
                            final result = await Get.toNamed('/solicitacoes/hub', arguments: solicitacaoObjeto);                             
                            //Get.toNamed('/solicitacoes/hub', arguments: solicitacaoObjeto);
                            if (result == true) {
                              Uteis.openDialog();
                              await solic.obtemSolic(); // Atualiza os dados na loja
                              Uteis.closeDialog();
                            }
                          } else {                                                                           
                            Uteis.showSnack(titulo: "Falha!", mensagem: resp.mensagem);
                          }                                 
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- TOPO DO CARD: CTR, COD e Datas ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.tag, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        "CTR: ${item.ctr}  •  COD: ${item.cod}",
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14),
                                      const SizedBox(width: 6),
                                      Text(
                                        item.dataEmissao ?? '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // --- DESCRIÇÃO PRINCIPAL ---
                              Text(                                    
                                item.descricao ?? 'Sem Descrição',
                                maxLines: 2, // Limita o texto para o card não ficar gigante
                                overflow: TextOverflow.ellipsis, // Adiciona os "..." no final
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                      
                              // --- RODAPÉ: Status, Solicitante e Prioridade ---
                              Row(
                                children: [
                                  // Chip de Status
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(                                     
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(width: 1),
                                    ),
                                    child: Text(
                                      item.status ?? 'Sem status',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: corStatus),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Solicitante
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.person_outline, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.solicitante ?? 'Anônimo',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Prioridade
                                  Row(
                                    children: [
                                      Icon(Icons.flag, size: 16, color: corPrio),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.prioridade ?? 'Sem Prioridade',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: corPrio),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}