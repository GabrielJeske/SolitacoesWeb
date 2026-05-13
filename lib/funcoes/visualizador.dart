import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web; // Importação nova

class VisualizadorUrl {
  
  static void abrir(String nomeArquivo, String urlAnexo) {
    
    // 1. Verifica a extensão
    final extensao = nomeArquivo.split('.').last.toLowerCase();
    final isImagem = ['jpg', 'jpeg', 'png', 'webp', 'bmp'].contains(extensao);

    if (isImagem) {
      // 2. Se for imagem, exibe no Dialog usando a URL (Network)
      Get.defaultDialog(       
          backgroundColor: Colors.grey.shade900, // Fundo Dark Mode
      radius: 16,
      contentPadding: EdgeInsets.zero, // Removemos o padding padrão para a imagem encostar nas bordas
      titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      
      // =========================================================
      // TÍTULO CUSTOMIZADO (Mostra o nome do arquivo)
      // =========================================================
      title: '', // Deixamos vazio para usar o titleStyle abaixo
      titleStyle: const TextStyle(fontSize: 0), // Esconde o título padrão do Get
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
                  child: Image.network(
                    urlAnexo,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.white, size: 50),
                          Text("Erro ao carregar imagem", style: TextStyle(color: Colors.white))
                        ],
                      );
                    },
                  ),
                ),
              ),                          
            ],
          ),      
      );
    } else {
      // 3. Se não for imagem (PDF, Doc, etc), abre a URL numa nova aba
      // O navegador decide se baixa ou exibe (ex: PDF abre, Zip baixa)
      web.window.open(urlAnexo, "_blank");
    }
  }
}