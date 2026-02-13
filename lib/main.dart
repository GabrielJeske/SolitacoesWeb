import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solicitacoes/funcoes/login.dart';
import 'package:solicitacoes/routes.dart';
import 'package:solicitacoes/store/arquivos_mob.dart';
import 'package:solicitacoes/store/login_mob.dart';
import 'package:solicitacoes/store/usuario_mob.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await box.erase();
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
    //Cores do App
    const speedBlack = Color(0xFF080808);   // Quase preto absoluto (Fundo)
    const speedCard = Color(0xFF1E1E1E);    // Cinza escuro (Cards/Inputs)
    const speedRed = Color(0xFFC62828);     // Vermelho do Logo (Ações principais)
    const speedRedop = Color.fromARGB(255, 187, 70, 70);     // Vermelho do Logo (Ações principais)
    const speedBlue = Color(0xFF1565C0);    // Azul do Logo (Destaques secundários)
    const textWhite = Color(0xFFEEEEEE);    // Branco gelo para leitura

    return GetMaterialApp(
      title: 'Solicitacoes',
      debugShowCheckedModeBanner: false,      
      theme: ThemeData(      
        useMaterial3: false,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: speedBlack,
        colorScheme: const ColorScheme.dark(
          primary: speedRed,      // Botões e focos principais        
          secondary: speedBlue,   // Floating actions, switches
          surface: speedCard,     // Cor de fundo dos Cards e Sheets
          onSurface: textWhite,   // Cor do texto em cima dos cards
          error: Color(0xFFCF6679),
        ),
        // AppBar: Preta com texto branco
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Deixa transparente para fundir com o fundo
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textWhite,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          iconTheme: IconThemeData(color: speedBlue), // Ícones da AppBar em Azul
        ),

        // Inputs (TextFields): Fundo escuro com borda sutil
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: speedCard,
          labelStyle: TextStyle(color: Colors.grey.shade400),
          prefixIconColor: speedBlue, // Ícones dentro do input
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none, // Sem borda quando inativo (mais limpo)
          ),
          enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(8),
             borderSide: BorderSide(color: Colors.grey.shade800),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: speedRed, width: 2), // Fica vermelho ao digitar
          ),
        ),

        // Botões: Vermelhos para chamar atenção (Ação)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: speedRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            shadowColor: speedRedop, // Sombra vermelha brilhante (Neon effect)
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            backgroundColor: speedRed, // Mesmo fundo vermelho
            foregroundColor: Colors.white, // Ícone branco
            
            // Copiando as mesmas propriedades do ElevatedButton
            elevation: 5,
            shadowColor: speedRed, // Sombra neon (speedRedop)
            
            // O padding define o tamanho/formato. 
            // Como é 'igual', mantive retangular. Se quiser quadrado, use EdgeInsets.all(15)
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Cards: Cinza escuro flutuando no preto
        cardTheme: CardThemeData(
          color: speedCard,
          elevation: 4,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade900, width: 1), // Borda fina sutil
          ),
        ),
      ),
      initialRoute: '/login',
      getPages: Routes.routes,
    );
  }
}

