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
  final TextEditingController _tapeAlphabetController = TextEditingController();
  final TextEditingController _initialMarkerController =
      TextEditingController();
  final TextEditingController _blankSymbolController = TextEditingController();
  final TextEditingController _transitionsController = TextEditingController();
  final TextEditingController _initialStateController = TextEditingController();
  final TextEditingController _tapeController = TextEditingController();
  final TextEditingController _finalStatesController = TextEditingController();

  String _result = '';
  String _transitions = '';

  Future<void> _simulate() async {
    print("Simulação iniciada...");
    try {
      final response = await http
          .post(
            Uri.parse('http://localhost:5000/simulate'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'estados': _statesController.text
                  .split(' ')
                  .map((s) => s.trim())
                  .toList(),
              'alfabeto': _alphabetController.text
                  .split(' ')
                  .map((s) => s.trim())
                  .toList(),
              'alfabeto_fita': _tapeAlphabetController.text
                  .split(' ')
                  .map((s) => s.trim())
                  .toList(),
              'marcador_inicio': _initialMarkerController.text.trim(),
              'simbolo_vazio': _blankSymbolController.text.trim(),
              'transicao': _transitionsController.text
                  .split(';')
                  .map((t) => t.trim())
                  .toList(),
              'estado_inicial': _initialStateController.text.trim(),
              'fita': _tapeController.text.trim(),
              'final_estados': _finalStatesController.text
                  .split(' ')
                  .map((s) => s.trim())
                  .toList(),
            }),
          )
          .timeout(Duration(seconds: 10)); // Timeout de 10 segundos

      print("Resposta recebida: ${response.statusCode}");
      print("Corpo da resposta: ${response.body}");

      if (response.statusCode == 200) {
        final resultData = jsonDecode(response.body);
        if (resultData['error'] != null) {
          setState(() {
            _result = 'Erro: ${resultData['error']}';
            _transitions = '';
          });
        } else {
          setState(() {
            _result = "Fita Final: ${resultData['final_fita']}\n"
                "Estado Final: ${resultData['final_state']}\n"
                "Resultado: ${resultData['resultado']}";
            _transitions =
                "Transições Realizadas:\n${resultData['transicoes'].join('\n')}";
          });
        }
      } else {
        setState(() {
          _result = 'Erro na simulação: ${response.body}';
          _transitions = '';
        });
      }
    } catch (e) {
      print("Erro na simulação: $e");
      setState(() {
        _result = 'Erro: $e';
        _transitions = '';
      });
    }
  }

  void _clearFields() {
    _statesController.clear();
    _alphabetController.clear();
    _tapeAlphabetController.clear();
    _initialMarkerController.clear();
    _blankSymbolController.clear();
    _transitionsController.clear();
    _initialStateController.clear();
    _tapeController.clear();
    _finalStatesController.clear();
    setState(() {
      _result = '';
      _transitions = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Máquina de Turing',
          style: TextStyle(fontSize: 15),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
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
              controller: _tapeAlphabetController,
              decoration: InputDecoration(
                labelText: 'Alfabeto da Fita (separado por espaço)',
              ),
            ),
            TextField(
              controller: _initialMarkerController,
              decoration: InputDecoration(
                labelText: 'Marcador de Início da Fita',
              ),
            ),
            TextField(
              controller: _blankSymbolController,
              decoration: InputDecoration(
                labelText: 'Símbolo Vazio da Fita',
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
            Text(_result),
            SizedBox(height: 20),
            Text(
              'Transições Realizadas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_transitions),
          ],
        ),
      ),
    );
  }
}
