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

  late Map<String, dynamic> _results = {};

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final paddingHorizontal = MediaQuery.of(context).size.width * 0.5;
    final paddingVertical = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Automato Simulator'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          /* padding: EdgeInsets.only(
              left: paddingHorizontal,
              right: paddingHorizontal,
              top: paddingVertical,
              bottom: paddingVertical),*/
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextField(
                    controller: _typeController,
                    labelText: 'Tipo de autômato (AFD/AFN)',
                  ),
                  _buildTextField(
                    controller: _statesController,
                    labelText: 'Estados (separados por espaço)',
                  ),
                  _buildTextField(
                    controller: _alphabetController,
                    labelText: 'Alfabeto (separado por espaço)',
                  ),
                  _buildTextField(
                    controller: _transitionsController,
                    labelText: 'Transições (estado,símbolo,próximo_estado)',
                  ),
                  _buildTextField(
                    controller: _startStateController,
                    labelText: 'Estado inicial',
                  ),
                  _buildTextField(
                    controller: _acceptStatesController,
                    labelText: 'Estados de aceitação (separados por espaço)',
                  ),
                  _buildTextField(
                    controller: _wordsController,
                    labelText: 'Palavras para simulação (separadas por espaço)',
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _simulateAutomato,
                    child: Text('Simular'),
                  ),
                  SizedBox(height: 20),
                  _results.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _results.entries.map((entry) {
                            return Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            );
                          }).toList(),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String labelText}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
