import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solicitacoes/routes.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';
import 'package:solicitacoes/store/login_mob.dart';
import 'package:solicitacoes/store/usuario_mob.dart';
import 'package:solicitacoes/tema.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await GetStorage.init();
  
  Get.put(LoginMob());
  Get.put(ArquivosMob());
  Get.put(UsuarioMob());  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {    

    return GetMaterialApp(
      title: 'Solicitacoes',
      debugShowCheckedModeBanner: false,      
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/login',
      getPages: Routes.routes,
    );
  }
}

