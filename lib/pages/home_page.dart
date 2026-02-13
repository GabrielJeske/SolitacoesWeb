import 'package:flutter/material.dart';
import 'package:solicitacoes/widgets/cultom_drawer.dart';
import 'package:solicitacoes/widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(title: 'Home'),
      drawer: CustomDrawer(),
      body: Center(      
        child: Column(        
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Speed System'),
            ElevatedButton(
              onPressed: () async {
                
              },
              child: const Text('Upload'),
            )
          ],
        ),
      ),       
    );
  }
}
