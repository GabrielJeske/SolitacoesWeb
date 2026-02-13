import 'package:flutter/material.dart';

// NOVO: Widget Auxiliar para exibir cada Anexo (Melhor que o ListTile)
class AnexoItem extends StatelessWidget {
  final String nome;
  final VoidCallback onRemove;

  const AnexoItem({
    super.key,
    required this.nome,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        // O fundo é um azul bem clarinho
        color: Colors.blue.shade50, 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, size: 18, color: Colors.blue),
          const SizedBox(width: 6),
          // Limita o texto para não quebrar o layout horizontal
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              nome,
              overflow: TextOverflow.ellipsis,
              // CORREÇÃO AQUI: Definindo a cor do texto para preto (black87) para contraste
              style: const TextStyle(fontSize: 13, color: Colors.black87), 
            ),
          ),
          // Botão de remoção (ícone de fechar)
          InkWell(
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Icon(
                Icons.close,
                size: 14,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}