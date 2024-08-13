import 'package:flutter/material.dart';

class Painel extends StatelessWidget {
  const Painel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/AFD');
                  },
                  child: Text('Simulador de AFD e AFN'),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Maquina');
                  },
                  child: Text('Maquina de Turing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
