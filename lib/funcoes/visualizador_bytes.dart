import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// NOVAS IMPORTAÇÕES
import 'package:web/web.dart' as web;
import 'dart:js_interop'; // Necessário para converter dados para o navegador

class VisualizadorBytes {
  
  static void abrir(String nomeArquivo, Uint8List? bytes) {
    if (bytes == null) return;

    final extensao = nomeArquivo.split('.').last.toLowerCase();
    final isImagem = ['jpg', 'jpeg', 'png', 'webp', 'bmp'].contains(extensao);

    if (isImagem) {
      Get.defaultDialog(
       backgroundColor: Colors.grey.shade900, // Fundo Dark Mode
      radius: 16,
      contentPadding: EdgeInsets.zero, // Removemos o padding padrão para a imagem encostar nas bordas
      titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),            
      title: '', // Deixamos vazio para usar o titleStyle abaixo
      titleStyle: const TextStyle(fontSize: 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        nomeArquivo,
                        overflow: TextOverflow.ellipsis, // Adiciona "..." se o nome for longo
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),   
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.white10), 
              Container(
                constraints: BoxConstraints(
                  maxWidth: 800, // Largura máxima confortável na Web
                  maxHeight: Get.height * 0.8, // Ocupa até 80% da altura da tela (evita rolagem excessiva)
                ),
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Image.memory(bytes)
                )
              ),              
            ],
          ),
        
      );
    } else {
      // --- LÓGICA ATUALIZADA PARA PACKAGE:WEB ---
      
      // 1. Cria o Blob (arquivo na memória) convertendo para JS
      final blob = web.Blob([bytes.toJS].toJS);
      
      // 2. Cria a URL temporária
      final url = web.URL.createObjectURL(blob);
      
      // 3. Cria o elemento <a> (link) invisível
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = nomeArquivo;
      
      // 4. Clica no link para baixar
      anchor.click();
      
      // 5. Limpa a memória
      web.URL.revokeObjectURL(url);
    }
  }
}