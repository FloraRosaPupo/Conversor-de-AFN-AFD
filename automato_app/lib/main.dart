import 'package:automato_app/AFD.dart';
import 'package:automato_app/Maquina.dart';
import 'package:automato_app/painel.dart';
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
