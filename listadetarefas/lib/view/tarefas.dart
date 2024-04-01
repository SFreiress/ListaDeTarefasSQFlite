import 'package:flutter/material.dart';
import 'package:listadetrefas/model/model.dart';

class TarefaListScreen extends StatefulWidget {
  @override
  _TarefaListScreenState createState() => _TarefaListScreenState();
}

class _TarefaListScreenState extends State<TarefaListScreen> {
  DatabaseProvider databaseProvider = DatabaseProvider();
  List<Tarefa> tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async {
    List<Tarefa> tarefasList = await databaseProvider.listarTarefas();
    setState(() {
      tarefas = tarefasList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(tarefas[index].nome ?? ''),
            subtitle: Text(tarefas[index].descricao ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                _exibirConfirmacaoExclusao(context, tarefas[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _adicionarEditarTarefa(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _exibirConfirmacaoExclusao(
      BuildContext context, Tarefa tarefa) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Tem certeza de que deseja excluir a tarefa "${tarefa.nome}"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () async {
                await databaseProvider.excluirTarefa(tarefa.id!);
                _carregarTarefas();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _adicionarEditarTarefa(BuildContext context,
      [Tarefa? tarefa]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TarefaFormScreen(tarefa: tarefa),
      ),
    );

    if (resultado != null && resultado) {
      _carregarTarefas();
    }
  }
}

class TarefaFormScreen extends StatefulWidget {
  final Tarefa? tarefa;

  TarefaFormScreen({this.tarefa});

  @override
  _TarefaFormScreenState createState() => _TarefaFormScreenState();
}

class _TarefaFormScreenState extends State<TarefaFormScreen> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _nomeController.text = widget.tarefa!.nome ?? '';
      _descricaoController.text = widget.tarefa!.descricao ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Tarefa'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição da Tarefa'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_nomeController.text.isNotEmpty) {
                  Tarefa novaTarefa = Tarefa(
                    widget.tarefa?.id,
                    _nomeController.text,
                    _descricaoController.text,
                  );
                  if (widget.tarefa == null) {
                    await DatabaseProvider().criarTarefa(novaTarefa);
                  } else {
                    await DatabaseProvider().alterarTarefa(novaTarefa);
                  }
                  Navigator.pop(context, true);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
