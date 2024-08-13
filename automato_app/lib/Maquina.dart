import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: TuringApp(),
  ));
}

class TuringApp extends StatefulWidget {
  @override
  _TuringAppState createState() => _TuringAppState();
}

class _TuringAppState extends State<TuringApp> {
  final TextEditingController _statesController = TextEditingController();
  final TextEditingController _alphabetController = TextEditingController();
  final TextEditingController _transitionsController = TextEditingController();
  final TextEditingController _initialStateController = TextEditingController();
  final TextEditingController _tapeController = TextEditingController();
  final TextEditingController _finalStatesController = TextEditingController();
  String _result = '';

  Future<void> _simulate() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/simulate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'states': _statesController.text.split(' '),
          'alphabet': _alphabetController.text.split(' '),
          'transitions': _transitionsController.text.split(';'),
          'initial_state': _initialStateController.text,
          'tape': _tapeController.text,
          'final_states': _finalStatesController.text.split(' '),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _result = response.body;
        });
      } else {
        setState(() {
          _result = 'Erro na simulação: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Erro: $e';
      });
    }
  }

  void _clearFields() {
    _statesController.clear();
    _alphabetController.clear();
    _transitionsController.clear();
    _initialStateController.clear();
    _tapeController.clear();
    _finalStatesController.clear();
    setState(() {
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Maquina de Turing',
          style: TextStyle(fontSize: 15),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ), // Altere o ícone aqui
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _statesController,
              decoration: InputDecoration(
                labelText: 'Estados (separados por espaço)',
              ),
            ),
            TextField(
              controller: _alphabetController,
              decoration: InputDecoration(
                labelText: 'Alfabeto (separado por espaço)',
              ),
            ),
            TextField(
              controller: _transitionsController,
              decoration: InputDecoration(
                labelText:
                    'Transições (formato estado,símbolo,novo estado,nova escrita,movimento; separadas por ";")',
              ),
            ),
            TextField(
              controller: _initialStateController,
              decoration: InputDecoration(
                labelText: 'Estado inicial',
              ),
            ),
            TextField(
              controller: _tapeController,
              decoration: InputDecoration(
                labelText: 'Fita inicial',
              ),
            ),
            TextField(
              controller: _finalStatesController,
              decoration: InputDecoration(
                labelText: 'Estados finais (separados por espaço)',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _simulate,
                  child: Text('Simular'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: Text('Limpar'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Resultado:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
