import 'package:flutter/material.dart';
import 'package:listadetrefas/view/login/login.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Configurações de tema podem ser ajustadas conforme necessário
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(), // Definindo LoginScreen como a tela inicial
    );
  }
}
