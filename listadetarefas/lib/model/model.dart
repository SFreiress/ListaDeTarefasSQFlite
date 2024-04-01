import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tarefas = "tarefas";
final String idTarefa = "idTarefa";
final String nomeTarefa = "nomeTarefa";
final String descricaoTarefa = "descricaoTarefa";

final String usuarios = "usuarios";
final String idUsuario = "idUsuario";
final String emailUsuario = "emailUsuario";
final String senhaUsuario = "senhaUsuario";

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider.internal();

  factory DatabaseProvider() => _instance;

  DatabaseProvider.internal();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "listadetarefas.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
          "CREATE TABLE $tarefas($idTarefa INTEGER PRIMARY KEY, $nomeTarefa TEXT, $descricaoTarefa TEXT)");
      await db.execute(
          "CREATE TABLE $usuarios($idUsuario INTEGER PRIMARY KEY, $emailUsuario TEXT, $senhaUsuario TEXT)");
    });
  }

  Future<Tarefa> criarTarefa(Tarefa tarefa) async {
    Database dbTarefas = await db;
    tarefa.id = await dbTarefas.insert(tarefas, tarefa.toMap());
    return tarefa;
  }

  Future<Tarefa?> buscarTarefa(int id) async {
    Database? dbTarefas = await db;
    List<Map> maps = await dbTarefas.query(tarefas,
        columns: [idTarefa, nomeTarefa, descricaoTarefa],
        where: "$idTarefa = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Tarefa.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> excluirTarefa(int id) async {
    Database? dbTarefas = await db;
    return await dbTarefas
        .delete(tarefas, where: "$idTarefa = ?", whereArgs: [id]);
  }

  Future<int> alterarTarefa(Tarefa tarefa) async {
    Database? dbTarefas = await db;
    return await dbTarefas.update(tarefas, tarefa.toMap(),
        where: "$idTarefa = ?", whereArgs: [tarefa.id]);
  }

  Future<List<Tarefa>> listarTarefas() async {
    Database? dbTarefas = await db;
    List<dynamic> listMap = await dbTarefas.rawQuery("SELECT * FROM $tarefas");
    List<Tarefa> listarTarefa =
        listMap.map((item) => Tarefa.fromMap(item)).toList();
    return listarTarefa;
  }

  Future<Usuario> criarUsuario(Usuario usuario) async {
    Database dbUsuarios = await db;
    usuario.id = await dbUsuarios.insert(usuarios, usuario.toMap());
    return usuario;
  }

  Future<Usuario?> buscarUsuario(int id) async {
    Database? dbUsuarios = await db;
    List<Map> maps = await dbUsuarios.query(usuarios,
        columns: [idUsuario, emailUsuario, senhaUsuario],
        where: "$idUsuario = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> excluirUsuario(int id) async {
    Database? dbUsuarios = await db;
    return await dbUsuarios
        .delete(usuarios, where: "$idUsuario = ?", whereArgs: [id]);
  }

  Future<int> alterarUsuario(Usuario usuario) async {
    Database? dbUsuarios = await db;
    return await dbUsuarios.update(usuarios, usuario.toMap(),
        where: "$idUsuario = ?", whereArgs: [usuario.id]);
  }

  Future<List> listarUsuarios() async {
    Database? dbUsuarios = await db;
    List listMap = await dbUsuarios.rawQuery("SELECT * FROM $usuarios");
    List<Usuario> listarUsuarios = [];
    for (Map m in listMap) {
      listarUsuarios.add(Usuario.fromMap(m));
    }
    return listarUsuarios;
  }
}

class Tarefa {
  int? id;
  String? nome;
  String? descricao;

  Tarefa(this.id, this.nome, this.descricao);

  Tarefa.fromMap(Map map) {
    id = map[idTarefa];
    nome = map[nomeTarefa];
    descricao = map[descricaoTarefa];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idTarefa: id,
      nomeTarefa: nome,
      descricaoTarefa: descricao,
    };
    if (id != null) {
      map[idTarefa] = id;
    }
    return map;
  }
}

class Usuario {
  int? id;
  String? email;
  String? senha;

  Usuario(this.id, this.email, this.senha);

  Usuario.fromMap(Map map) {
    id = map[idUsuario];
    email = map[emailUsuario];
    senha = map[senhaUsuario];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idUsuario: id,
      emailUsuario: email,
      senhaUsuario: senha,
    };
    if (id != null) {
      map[idUsuario] = id;
    }
    return map;
  }
}
