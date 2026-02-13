import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../funcoes/login.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessando as cores do tema que definimos no main.dart
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      // Fundo escuro vindo do tema (o cinza escuro/preto que configuramos)
      backgroundColor: colors.surface,
      
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // --- CABEÇALHO DO MENU ---
                    const SizedBox(height: 50),
                    // Ícone do Raio (Identidade Speed System)
                    Icon(
                      Icons.bolt_rounded, // Ícone de raio
                      size: 70,
                      color: colors.primary, // Vermelho
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "SPEED SYSTEM",
                      style: TextStyle(
                        color: colors.onSurface, // Branco
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0, // Espaçamento moderno
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey.shade800, thickness: 1),
                    const SizedBox(height: 20),

                    // --- ITEM: INÍCIO ---
                    ListTile(
                      leading: const Icon(Icons.home_filled),
                      iconColor: colors.secondary, // Azul
                      title: const Text('Início'),
                      textColor: colors.onSurface, // Branco
                      onTap: () {
                        Get.toNamed('/');
                      },
                    ),

                    // --- GRUPO: SOLICITAÇÕES ---
                    Theme(
                      // Remove as linhas divisórias padrão do ExpansionTile para um visual limpo
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Usuários'),
                        
                        // Cores quando FECHADO
                        collapsedIconColor: colors.secondary, // Azul
                        collapsedTextColor: colors.onSurface, // Branco
                        
                        // Cores quando ABERTO (Destaque)
                        iconColor: colors.primary, // Vermelho
                        textColor: colors.primary, // Vermelho
                        
                        children: [

                          if( "geral" == box.read("Cadastrar Usuarios") )                          
                          _buildSubItem(context, Icons.add_circle_outline, 'Inclusão', '/usuarios/inclusao'),
                          if( "geral" == box.read("Alterar Usuarios") )
                          _buildSubItem(context, Icons.edit_outlined, 'Alteração', '/usuarios/alteracao'),
                          if( "geral" == box.read("Alterar Usuarios") )
                          _buildSubItem(context, Icons.search, 'Consulta', '/usuarios/consulta'),                         
                          _buildSubItem(context, Icons.lock_outline_rounded, 'Alterar Senha', '/usuarios/senha'),                         
                        ],
                      ),
                    ),
                    Theme(
                      // Remove as linhas divisórias padrão do ExpansionTile para um visual limpo
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        leading: const Icon(Icons.inventory_2),
                        title: const Text('Solicitações'),
                        
                        // Cores quando FECHADO
                        collapsedIconColor: colors.secondary, // Azul
                        collapsedTextColor: colors.onSurface, // Branco
                        
                        // Cores quando ABERTO (Destaque)
                        iconColor: colors.primary, // Vermelho
                        textColor: colors.primary, // Vermelho
                        
                        children: [
                          _buildSubItem(context, Icons.add_circle_outline, 'Inclusão', '/solicitacoes/inclusao'),
                          _buildSubItem(context, Icons.edit_outlined, 'Alteração', '/solicitacoes/alteracao'),
                          _buildSubItem(context, Icons.search, 'Consulta', '/solicitacoes/consulta'),
                          _buildSubItem(context, Icons.delete_outline, 'Exclusão', '/solicitacoes/exclusao'),
                          _buildSubItem(context, Icons.speed, 'Speed Central', '/solicitacoes/speed'),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // --- RODAPÉ ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        'Versão 25.0922.123',
                        style: TextStyle(
                          color: colors.onSurface, // Cinza bem discreto
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Método auxiliar para criar os itens do submenu (evita repetição de código)
  Widget _buildSubItem(BuildContext context, IconData icon, String title, String route) {
    final colors = Theme.of(context).colorScheme;
    
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32, right: 16), // Recuo para dar ideia de hierarquia
      leading: Icon(icon, size: 20),
      iconColor: colors.secondary, // Ícones azuis nos subitens
      title: Text(title),
      textColor: colors.onSurface, // Branco suave
      dense: true, // Deixa o item um pouco mais compacto
      onTap: () {
        Get.toNamed(route);
      },
    );
  }
}