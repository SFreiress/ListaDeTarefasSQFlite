import 'package:flutter/material.dart';
import 'package:listadetrefas/model/model.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final DatabaseProvider _dbProvider = DatabaseProvider();

  void _registrar() async {
    Usuario novoUsuario =
        Usuario(null, _emailController.text, _senhaController.text);
    await _dbProvider.criarUsuario(novoUsuario);
    Navigator.pop(context); // Volta para a tela de login após o registro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _registrar,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
