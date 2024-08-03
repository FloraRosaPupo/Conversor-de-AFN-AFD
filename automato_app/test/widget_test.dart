import 'package:automato_app/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testa interação com o widget AFDApp', (WidgetTester tester) async {
    // Construa o app e acione um frame.
    await tester.pumpWidget(MaterialApp(home: AFDApp()));

    // Verifique se os campos e botões estão presentes
    expect(find.text('Tipo de autômato (AFD ou AFN)'), findsOneWidget);
    expect(find.text('Estados (separados por espaço)'), findsOneWidget);

    // Insira texto nos campos de texto
    await tester.enterText(find.byType(TextField).at(0), 'AFD');
    await tester.enterText(find.byType(TextField).at(1), 'q0 q1');
    await tester.enterText(find.byType(TextField).at(2), 'a b');
    await tester.enterText(find.byType(TextField).at(3), 'q0,a,q1 q1,b,q0');
    await tester.enterText(find.byType(TextField).at(4), 'q0');
    await tester.enterText(find.byType(TextField).at(5), 'q1');
    await tester.enterText(find.byType(TextField).at(6), 'ab');

    // Toque no botão de simulação
    await tester.tap(find.text('Simular'));
    await tester.pumpAndSettle(); // Aguarde a conclusão da animação e atualização de widgets

    // Adicione um atraso para garantir que o texto esteja visível
    await Future.delayed(Duration(seconds: 1));

    // Verifique se o resultado esperado está presente
    expect(find.textContaining('Palavra: ab'), findsOneWidget);
  });
}
