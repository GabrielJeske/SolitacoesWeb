import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';

class Alteracaosolic extends StatefulWidget {
  const Alteracaosolic({super.key});

  @override
  State<Alteracaosolic> createState() => _AlteracaosolicState();
}

class _AlteracaosolicState extends State<Alteracaosolic> {
  // Vamos usar lazy put ou find seguro
  final ArquivosMob solic = Get.find<ArquivosMob>();

  @override
  void initState() {
    super.initState();
    // Executa apenas APÓS o primeiro frame para não bloquear a navegação
    WidgetsBinding.instance.addPostFrameCallback((_) {
      solic.obtemSolic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Alteração de Solicitações"),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // --- Cabeçalho Simples ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Observer(
              builder: (context) {
                return Row(
                  children: [
                    SizedBox(width: 15),
                    Text(
                      'Status:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        // Texto Branco
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 15),
                    Checkbox(
                      value: solic.filtros['Pendente'],
                      activeColor: Theme.of(context).colorScheme.primary,
                      // Borda cinza clara para ver onde clicar no escuro
                      side: BorderSide(color: Colors.grey.shade500, width: 2),
                      onChanged:
                          (bool? value) =>
                              solic.setFiltro('Pendente', value ?? false),
                    ),
                    Text(
                      'Pendente',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        // Texto Branco
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 10),
                    Checkbox(
                      value: solic.filtros['Em Andamento'],
                      activeColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Colors.grey.shade500, width: 2),
                      onChanged:
                          (bool? value) =>
                              solic.setFiltro('Em Andamento', value ?? false),
                    ),
                    Text(
                      'Em Andamento',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                
                    SizedBox(width: 10),
                    Checkbox(
                      value: solic.filtros['Concluido'],
                      activeColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Colors.grey.shade500, width: 2),
                      onChanged:
                          (bool? value) =>
                              solic.setFiltro('Concluido', value ?? false),
                    ),
                    Text(
                      'Concluido',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      'Prioridade:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        // Texto Branco
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 15),
                    Checkbox(
                      value: solic.filtros['Urgente'],
                      activeColor: Theme.of(context).colorScheme.primary,
                      // Borda cinza clara para ver onde clicar no escuro
                      side: BorderSide(color: Colors.grey.shade500, width: 2),
                      onChanged:
                          (bool? value) =>
                              solic.setFiltro('Urgente', value ?? false),
                    ),
                    Text(
                      'Urgente',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        // Texto Branco
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 10),
                    Checkbox(
                      value: solic.filtros['Importante'],
                      activeColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Colors.grey.shade500, width: 2),
                      onChanged:
                          (bool? value) =>
                              solic.setFiltro('Importante', value ?? false),
                    ),
                    Text(
                      'Importante',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                
                    SizedBox(width: 10),
                    Checkbox(
                      value: solic.filtros['Normal'],
                      activeColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Colors.grey.shade500, width: 2),
                      onChanged:
                          (bool? value) =>
                              solic.setFiltro('Normal', value ?? false),
                    ),
                    Text(
                      'Normal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 10),
                
                    Spacer(),
                  ],
                );
              }
            ),
          ),
          const Divider(),

          // --- LISTA SEGURA (OBSERVER) ---
          Expanded(
            child: Observer(
              builder: (_) {
                if (solic.listaFiltrada.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [                                              
                        Text("Nenhuma Solicitacao Encontrada ..."),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  // physics: const BouncingScrollPhysics(), // Opcional
                  itemCount: solic.listaFiltrada.length,
                  itemBuilder: (context, index) {
                    final item = solic.listaFiltrada[index];

                    // CARD OTIMIZADO (Sem TextFields, Sem Controllers)
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Linha 1: Título e ID
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "COD: ${item.cod}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),                                
                                Text(
                                  "Data Emissão: ${item.dataEmissao}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,                                      
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Linha 2: Status e Descrição
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSimpleLabel(
                                    "Status",
                                    item.status ?? 'Sem status',
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildSimpleLabel(
                                    "Solicitante",
                                    item.solicitante ?? 'Anonimo',
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildSimpleLabel(
                                    "Prioridade",
                                    item.prioridade ?? 'Sem Prioridade',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSimpleLabel(
                                    "Descricao",
                                    item.descricao ?? 'Sem Descricao',
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  // Widget super leve para exibir texto
  Widget _buildSimpleLabel(String titulo, String valor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
