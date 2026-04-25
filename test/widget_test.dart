import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Agregar tarea funciona correctamente', (
    WidgetTester tester,
  ) async {
    // Cargar la app
    await tester.pumpWidget(MiApp());

    // Verificar que el campo de texto existe
    expect(find.byType(TextField), findsOneWidget);

    // Escribir una tarea
    await tester.enterText(find.byType(TextField), 'Comprar pan');

    // Presionar el botón "Agregar"
    await tester.tap(find.text('Agregar'));
    await tester.pump();

    // Verificar que la tarea aparece en pantalla
    expect(find.text('Comprar pan'), findsOneWidget);
  });
}
