import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Uteis {
  // Abre o loading
  static void openDialog() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }
  }

  // Fecha o loading de forma segura
  static void closeDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  // Padroniza os Snackbars
  static void showSnack({required String titulo, required String mensagem, bool isErro = false}) {
    Get.snackbar(
      titulo,
      mensagem,
      backgroundColor: isErro ? Colors.red.shade800 : Colors.green.shade700,
      colorText: Colors.white,
    );
  }
}