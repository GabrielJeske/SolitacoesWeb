import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:solicitacoes/funcoes/date.dart';
import 'package:solicitacoes/funcoes/login.dart';
import 'package:solicitacoes/funcoes/solic_net.dart';
import 'package:solicitacoes/objetos/resposta.dart';
import 'package:solicitacoes/objetos/solicitacoes.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';

final TextEditingController cod = TextEditingController();
final TextEditingController data = TextEditingController();
final TextEditingController descricao = TextEditingController();
final TextEditingController solucao = TextEditingController();
final TextEditingController ticket = TextEditingController();

Solicitacoes solicitacao = Solicitacoes();

  void setField(String chave, dynamic value){  

    if (value != null && chave != '' && chave != ''){
      switch (chave) {
        case 'prioridade':
          box.write(chave, value);
        break;
        case 'descricao':
          box.write(chave, value);
        break;
        case 'status':
          box.write(chave, value);
        break;
        case 'solucao':
          box.write(chave, value);
        break;
        case 'ticket':
          box.write(chave, value);
        break;     
      }
    }
  }

  Future<void> salvaArq() async{
    final arq = Get.find<ArquivosMob>(); 
    
    for ( int a = 0 ; a < arq.anexos.length; a++){
      PlatformFile file = arq.anexos[a];      
      String? outputFile = await FilePicker.platform.saveFile(      
        fileName: file.name,
        initialDirectory: '/home/gabriel/app/',
        bytes: file.bytes,
      );
      if (outputFile == null){
        log('Deu null');
      }else{
        log('Deu algo: $outputFile');
      }

    }     
  }

  // altSolic(Solicitacoes solicitacao) {
  //   final arq = Get.find<ArquivosMob>(); 
  //   arq.anexos = ObservableList<PlatformFile>();
  //   data.text = solicitacao.dataEmissao ?? Data.getData;
  //   descricao.text = solicitacao.descricao ?? "";
  //   cod.text = solicitacao.cod ?? ""; 
  // }

  reset(){
    final arq = Get.find<ArquivosMob>(); 
    arq.anexosTicket = ObservableList<PlatformFile>();
    arq.anexosSpeed = ObservableList<PlatformFile>();
    ticket.text = "";
    solucao.text = "";    
  }
  resetSolic() async{
    final arq = Get.find<ArquivosMob>(); 
    arq.anexos = ObservableList<PlatformFile>();
    data.text = Data.getData;
    descricao.text = "";
    ApiResponse resp = await obtemCod(); 
    if (resp.sucesso){
      cod.text = resp.data["proxCod"];
    }else {
      cod.text = "0";
    }
  }



