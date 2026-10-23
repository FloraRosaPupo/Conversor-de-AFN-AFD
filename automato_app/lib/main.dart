import 'package:automato_app/features/automata/presentation/AFD.dart';
import 'package:automato_app/features/turing/presentation/Maquina.dart';
import 'package:automato_app/app/painel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => Painel(),
      '/AFD': (BuildContext context) => AFDApp(),
      '/Maquina': (BuildContext context) => TuringApp(),
    },
  ));
}
