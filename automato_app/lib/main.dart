import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() { 
  runApp(AutomatoApp());
}

class AutomatoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automato Simulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AutomatoHomePage(),
    );
  }
}

class AutomatoHomePage extends StatefulWidget {
  @override
  _AutomatoHomePageState createState() => _AutomatoHomePageState();
}

class _AutomatoHomePageState extends State<AutomatoHomePage> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _statesController = TextEditingController();
  final TextEditingController _alphabetController = TextEditingController();
  final TextEditingController _transitionsController = TextEditingController();
  final TextEditingController _startStateController = TextEditingController();
  final TextEditingController _acceptStatesController = TextEditingController();
  final TextEditingController _wordsController = TextEditingController();

  Map<String, dynamic> _results = {};

  Future<void> _simulateAutomato() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/simulate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'automaton_type': _typeController.text,
          'states': _statesController.text.split(' '),
          'alphabet': _alphabetController.text.split(' '),
          'transitions': _transitionsController.text.split(' '),
          'start_state': _startStateController.text,
          'accept_states': _acceptStatesController.text.split(' '),
          'words': _wordsController.text.split(' '),
        }),
      );

      print('StatusCode: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _results = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to simulate automato: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na simulação: $e');
      // Tratar erro, exibir mensagem ao usuário, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Automato Simulator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _typeController,
                decoration:
                    InputDecoration(labelText: 'Tipo de autômato (AFD/AFN)'),
              ),
              TextField(
                controller: _statesController,
                decoration: InputDecoration(
                    labelText: 'Estados (separados por espaço)'),
              ),
              TextField(
                controller: _alphabetController,
                decoration: InputDecoration(
                    labelText: 'Alfabeto (separado por espaço)'),
              ),
              TextField(
                controller: _transitionsController,
                decoration: InputDecoration(
                    labelText: 'Transições (estado,símbolo,próximo_estado)'),
              ),
              TextField(
                controller: _startStateController,
                decoration: InputDecoration(labelText: 'Estado inicial'),
              ),
              TextField(
                controller: _acceptStatesController,
                decoration: InputDecoration(
                    labelText: 'Estados de aceitação (separados por espaço)'),
              ),
              TextField(
                controller: _wordsController,
                decoration: InputDecoration(
                    labelText:
                        'Palavras para simulação (separadas por espaço)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simulateAutomato,
                child: Text('Simular'),
              ),
              SizedBox(height: 20),
              _results.isNotEmpty
                  ? Text(
                      'Resultados: \n${_results.toString()}',
                      style: TextStyle(fontSize: 16),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
