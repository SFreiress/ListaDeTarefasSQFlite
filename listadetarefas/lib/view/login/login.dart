import 'package:flutter/material.dart';
import 'package:listadetrefas/view/login/registro.dart';
import 'package:listadetrefas/model/model.dart';
import 'package:listadetrefas/view/tarefas.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _login() async {
    final String email = _emailController.text;
    final String senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, insira seu e-mail e senha'),
      ));
      return;
    }

    DatabaseProvider dbProvider = DatabaseProvider();
    List<Usuario> usuarios = await dbProvider.listarUsuarios() as List<Usuario>;

    for (Usuario usuario in usuarios) {
      if (usuario.email == email) {
        if (usuario.senha == senha) {
          // Usuário logado com sucesso, proceda conforme necessário
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login bem-sucedido!'),
          ));
          // Redirecione para a tela desejada após o login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TarefaListScreen()), // Chame TarefaListScreen() aqui
          );
          return;
        } else {
          // Senha incorreta
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Senha incorreta, tente novamente.'),
          ));
          return;
        }
      }
    }

    // Usuário não encontrado
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Usuário não encontrado.'),
    ));
  }

  void _navegarParaRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
              onPressed: _login,
              child: Text('Acessar'),
            ),
            TextButton(
              onPressed: _navegarParaRegistro,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
