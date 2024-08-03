
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AFDApp extends StatefulWidget {
  @override
  _AFDAppState createState() => _AFDAppState();
}

class _AFDAppState extends State<AFDApp> {
  final TextEditingController _tipoAutomatoController = TextEditingController();
  final TextEditingController _estadosController = TextEditingController();
  final TextEditingController _alfabetoController = TextEditingController();
  final TextEditingController _transicoesController = TextEditingController();
  final TextEditingController _estadoInicialController =
      TextEditingController();
  final TextEditingController _estadosAceitacaoController =
      TextEditingController();
  final TextEditingController _palavrasController = TextEditingController();
  bool _minimizar = false;
  String _resultado = '';

  @override
  void initState() {
    super.initState();
    _tipoAutomatoController.addListener(_updateVisibility);
  }

  @override
  void dispose() {
    _tipoAutomatoController.removeListener(_updateVisibility);
    _tipoAutomatoController.dispose();
    _estadosController.dispose();
    _alfabetoController.dispose();
    _transicoesController.dispose();
    _estadoInicialController.dispose();
    _estadosAceitacaoController.dispose();
    _palavrasController.dispose();
    super.dispose();
  }

  void _updateVisibility() {
    setState(() {});
  }

  Future<void> _simular() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/simular'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'tipo_automato': _tipoAutomatoController.text,
          'estados': _estadosController.text.split(' '),
          'alfabeto': _alfabetoController.text.split(' '),
          'transicoes': _transicoesController.text.split(' '),
          'estado_inicial': _estadoInicialController.text,
          'estados_aceitacao': _estadosAceitacaoController.text.split(' '),
          'palavras': _palavrasController.text.split(' '),
          'minimizar': _minimizar,
        }),
      );

      if (response.statusCode == 200) {
        final resultado = json.decode(response.body);
        setState(() {
          _resultado = resultado.entries.map((entry) {
            String palavra = entry.key;
            bool aceito = entry.value['aceito'];
            return 'Palavra: $palavra\nAceito: ${aceito ? "Sim" : "Não"}\n';
          }).join('\n');
        });
      } else {
        setState(() {
          _resultado = 'Erro na simulação: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _resultado = 'Erro: $e';
      });
    }
  }

  void _limparCampos() {
    _tipoAutomatoController.clear();
    _estadosController.clear();
    _alfabetoController.clear();
    _transicoesController.clear();
    _estadoInicialController.clear();
    _estadosAceitacaoController.clear();
    _palavrasController.clear();
    setState(() {
      _resultado = '';
      _minimizar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulador de AFD/AFN'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tipoAutomatoController,
              decoration: InputDecoration(
                labelText: 'Tipo de autômato (AFD ou AFN)',
              ),
            ),
            TextField(
              controller: _estadosController,
              decoration: InputDecoration(
                labelText: 'Estados (separados por espaço)',
              ),
            ),
            TextField(
              controller: _alfabetoController,
              decoration: InputDecoration(
                labelText: 'Alfabeto (separado por espaço)',
              ),
            ),
            TextField(
              controller: _transicoesController,
              decoration: InputDecoration(
                labelText: 'Transições (formato estado,símbolo,próximo estado)',
              ),
            ),
            TextField(
              controller: _estadoInicialController,
              decoration: InputDecoration(
                labelText: 'Estado inicial',
              ),
            ),
            TextField(
              controller: _estadosAceitacaoController,
              decoration: InputDecoration(
                labelText: 'Estados de aceitação (separados por espaço)',
              ),
            ),
            TextField(
              controller: _palavrasController,
              decoration: InputDecoration(
                labelText: 'Palavras para simulação (separadas por espaço)',
              ),
            ),
            Visibility(
              visible: _tipoAutomatoController.text.toUpperCase() == 'AFD',
              child: Row(
                children: [
                  Checkbox(
                    value: _minimizar,
                    onChanged: (bool? value) {
                      setState(() {
                        _minimizar = value!;
                      });
                    },
                  ),
                  Text('Minimizar AFD'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _simular,
                  child: Text('Simular'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _limparCampos,
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
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(_resultado),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
