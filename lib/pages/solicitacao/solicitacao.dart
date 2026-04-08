import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/controller/arq.dart';
import 'package:solicitacoes/controller/usuarios.dart';
import 'package:solicitacoes/funcoes/solic_net.dart';
import 'package:solicitacoes/funcoes/uteis.dart';
import 'package:solicitacoes/funcoes/visualizador.dart';
import 'package:solicitacoes/funcoes/visualizador_bytes.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/objetos/solicitacoes.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';
import 'package:solicitacoes/widgets/anexo.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';
import 'package:solicitacoes/controller/constantes.dart';
import 'package:solicitacoes/widgets/custom_textfield.dart';

class Solicitacao extends StatefulWidget {
  final Solicitacoes solicitacao;

  const Solicitacao({super.key, required this.solicitacao});

  @override
  State<Solicitacao> createState() => _SolicitacaoState();
}

class _SolicitacaoState extends State<Solicitacao> {
  final ArquivosMob solic = Get.find<ArquivosMob>();
   String? erroSolucao;
   String? erroTicket;


  @override
  void initState() {
    reset();
    super.initState();
    solic.setTicket(false);
  }

  @override
  void dispose() {
    reset();
    solic.setTicket(false);
    super.dispose();
  }

  // --- FUNÇÕES AUXILIARES DE UI E LÓGICA ---

  bool _isEven(String? cod) => (int.tryParse(cod ?? '0') ?? 0).isEven;

  Widget _buildInfoItem(IconData icon, String label, String value, Color iconColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, )),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, )),
          ],
        ),
      ],
    );
  }

  Widget _buildAnexoChip(String nomeArquivo, String urlAnexo) {
    return InkWell(
      onTap: () {      
        VisualizadorUrl.abrir(nomeArquivo, urlAnexo);
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.attach_file, size: 16,),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                nomeArquivo,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12,)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _executarAcao(Function acaoApi, String nomeAcao) async {
    Uteis.openDialog();
    ApiResponse resp = await acaoApi(widget.solicitacao);
     Uteis.closeDialog();
    if (resp.sucesso) {
      Get.back(result: true);
    } else {      
      Uteis.showSnack(titulo: "Falha", mensagem: resp.mensagem);
    }
  }

  // --- BUILD PRINCIPAL ---

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: const CustomAppBar(title: 'Solicitação'),
      drawer: const CustomDrawer(),
      body: Column(
        children: [           
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            elevation: 4,             
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Linha 1: CTR, COD e Data ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(                           
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "CTR: ${widget.solicitacao.ctr}  •  COD: ${widget.solicitacao.cod}",
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                      ),
                      Text(
                        "Emissão: ${widget.solicitacao.dataEmissao}",
                        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Colors.white10),
                  ),
      
                  // --- Linha 2: Descrição ---
                  Text(
                    widget.solicitacao.descricao ?? 'Sem Descrição',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
      
                  // --- Linha 3: Informações em Grid (Wrap) ---
                  Wrap(
                    spacing: 200.0,
                    runSpacing: 26.0,
                    children: [
                      Expanded(child: _buildInfoItem(Icons.info_outline, "Status", widget.solicitacao.status ?? '-', Colors.amber)),
                      Expanded(child: _buildInfoItem(Icons.person_outline, "Solicitante", widget.solicitacao.solicitante ?? '-', Colors.white70)),
                      Expanded(child: _buildInfoItem(Icons.priority_high, "Prioridade", widget.solicitacao.prioridade ?? '-', Colors.redAccent)),
                      Expanded(child: _buildInfoItem(Icons.engineering_outlined, "Técnico", widget.solicitacao.tecnico ?? '-', Colors.white70)),
                      Expanded(child: _buildInfoItem(Icons.code, "Desenvolvedor", widget.solicitacao.dev ?? '-', Colors.white70)),
                      if (widget.solicitacao.dataAceito != null && widget.solicitacao.dataAceito!.isNotEmpty)
                        Expanded(child: _buildInfoItem(Icons.check_circle_outline, "Data Aceito", widget.solicitacao.dataAceito!, Colors.green)),
                      if (widget.solicitacao.dataConclusao != null && widget.solicitacao.dataConclusao!.isNotEmpty)
                        Expanded(child: _buildInfoItem(Icons.done_all, "Conclusão", widget.solicitacao.dataConclusao!, Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if ((widget.solicitacao.status ?? '').toLowerCase() == "concluido")...[
                    Text (
                      "Solucão: ",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),  
                    Text(
                      widget.solicitacao.solucao ?? 'Sem Solucão',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),  
                  ],                     
                  // --- Linha 4: Anexos da Solicitação ---
                  if (widget.solicitacao.anexos != null && widget.solicitacao.anexos!.isNotEmpty) ...[
                    const Text("Anexos:", style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: widget.solicitacao.anexos!.map((anexo) {
                        final pathCompleto = anexo.toString();
                        final nomeArquivo = pathCompleto.split('/').last;
                        final urlAnexo = '$url$porta/solicitacao/anexo?ctr=${widget.solicitacao.ctr}&arquivo=$pathCompleto';
                        return _buildAnexoChip(nomeArquivo, urlAnexo);
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
      
                  // --- Linha 5: Solução (Em Andamento) ---
                  if (isSpeed() && (widget.solicitacao.status ?? '').toLowerCase() == 'desenvolvimento') ...[
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      label: 'Solução',
                      maxLines: 10, // Reduzido para não empurrar muito a tela
                      controller: solucao,
                      onChanged: (value) {
                        setField("solucao", value);
                        if (value.trim().length >= 10 && erroSolucao != null){
                          setState(() {
                            erroSolucao = null;
                          });
                        }
                      },
                      errorText: erroSolucao,
                                       
                    ),
                    const SizedBox(height: 20),
                  ],
      
                  // --- Linha 6: Botões de Ação Padronizados ---
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 10.0,
                    children: [
                      if (isSpeed() && (widget.solicitacao.status ?? '').toLowerCase() == 'pendente') ...[
                        ElevatedButton.icon(
                          onPressed: () => _executarAcao(aceitaSolic, "Aceitar"),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text("Aceitar"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _executarAcao(recusaSolic, "Recusar"),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text("Recusar"),
                        ),
                      ],
                      if (isSpeed() && (widget.solicitacao.status ?? '').toLowerCase() == 'desenvolvimento')
                        ElevatedButton.icon(
                          onPressed: () {
                            if (solucao.text.trim().length < 10){
                              setState(() {
                                erroSolucao = "A solução deve ter pelo menos 10 caracteres";
                              });
                              return;
                            }
                            setState(() {
                              erroSolucao= null;
                            });
                            _executarAcao(concluiSolic, "Concluir");
                          },
                          icon: const Icon(Icons.done_all, size: 18),
                          label: const Text("Concluir"),
                        ),
      
                      if ((widget.solicitacao.status ?? '').toLowerCase() != 'concluido')
                        OutlinedButton.icon(
                          onPressed: () => solic.setTicket(true),
                          icon: const Icon(Icons.forum_outlined, size: 18),
                          label: const Text("Novo Ticket"),                          
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // =========================================================
          // ÁREA DE CRIAÇÃO DE TICKET
          // =========================================================
          Observer(
            builder: (context) {
              if (!solic.ticket) return const SizedBox.shrink();
      
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 2,                 
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Novo Ticket", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      CustomTextfield(
                        label: 'Mensagem',
                        maxLines: 4,
                        controller: ticket,
                        onChanged: (value) {
                          setField("ticket", value);
                          if (value.trim().length >= 10 && erroTicket != null){
                            setState(() {
                              erroTicket = null;
                            });
                          }
                        },
                        errorText: erroTicket,
                      ),
                      const SizedBox(height: 10),
                      
                      // Lista de anexos locais sendo upados
                      if (solic.anexosTicket.isNotEmpty) ...[
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            itemCount: solic.anexosTicket.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (contextList, index) {
                              final anexo = solic.anexosTicket[index];
                              return InkWell(
                                onTap: () => VisualizadorBytes.abrir(anexo.name, anexo.bytes),
                                child: AnexoItem(
                                  nome: anexo.name,
                                  onRemove: () => solic.removerAnexoTicket(index),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                             if (ticket.text.trim().length < 10){
                                setState(() {
                                  erroTicket = "A mensagem deve conter pelo menos 10 caracteres!" ;
                                });
                                return;
                              }
                              setState(() { erroTicket = null; });
                              Uteis.openDialog();
                              ApiResponse resp = await incluiTicket(widget.solicitacao.cod ?? '', widget.solicitacao.ctr ?? '');
                              Uteis.closeDialog();
                              if (resp.sucesso) {                                                                    
                                Get.back(result: true);
                                reset();                                  
                               // Uteis.showSnack(titulo: "Sucesso!", mensagem: resp.mensagem);
                                solic.setTicket(false);
                              } else {                                  
                                Uteis.showSnack(titulo: "Falha!", mensagem: resp.mensagem);
                              }                              
                            },
                            icon: const Icon(Icons.send, size: 16),
                            label: const Text('Enviar Ticket'),
                          ),
                          const SizedBox(width: 15),
                          OutlinedButton.icon(
                            onPressed: () => solic.baixaAnexoTicket(),
                            icon: const Icon(Icons.attach_file, size: 16),
                            label: const Text("Anexar Arquivo"),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: "Cancelar",
                            onPressed: () => solic.setTicket(false),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
      
          // =========================================================
          // HISTÓRICO DE TICKETS (CHAT)
          // =========================================================
          if (widget.solicitacao.tickets != null && widget.solicitacao.tickets!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Observer(
                builder: (context) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Evita conflito com o scroll principal
                    itemCount: widget.solicitacao.tickets!.length,
                    shrinkWrap: true,
                    itemBuilder: (contextList, index) {
                      final ticket = widget.solicitacao.tickets![index];
                      final isEven = _isEven(ticket.cod);
      
                      return Align(
                        alignment: isEven ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75, // Ocupa até 75% da tela
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isEven 
                                    ? Theme.of(context).colorScheme.tertiaryContainer 
                                    : Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(15),
                              topRight: const Radius.circular(15),
                              bottomLeft: isEven ? const Radius.circular(15) : Radius.zero,
                              bottomRight: isEven ? Radius.zero : const Radius.circular(15),
                            ),
                            border: Border.all(color: Colors.white12, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ticket #${ticket.cod}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isEven ? Colors.blue.shade300 : Colors.green.shade300,
                                      ),
                                    ),
                                    Text(
                                      ticket.solicitante ?? 'Anônimo',
                                      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ticket.descricao ?? '',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                
                                // Anexos do Ticket padronizados
                                if (ticket.anexos != null && ticket.anexos!.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: ticket.anexos!.map((anexo) {
                                      final pathCompleto = anexo.toString();
                                      final nomeArquivo = pathCompleto.split('/').last;
                                      final urlAnexo = '$url$porta/solicitacao/anexo?ctr=${widget.solicitacao.ctr}&arquivo=$pathCompleto';
                                      return _buildAnexoChip(nomeArquivo, urlAnexo);
                                    }).toList(),
                                  ),
                                ],
      
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    ticket.emissao ?? '',
                                    style: const TextStyle(fontSize: 11),
                                  ),
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
            ]
        ],
      ),
    );
  }
}