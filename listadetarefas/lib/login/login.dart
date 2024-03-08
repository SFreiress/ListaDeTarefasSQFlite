import 'package:flutter/material.dart';
import 'cadastro.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Por favor, insira uma senha com pelo menos 8 caracteres';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Entrar'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 18)),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text('Registro'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
