import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_materialapp/main.dart';

void main() {
  testWidgets('Crear y visualizar usuario en lista', (
    WidgetTester tester,
  ) async {
    // Cargar app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Escribir en formulario
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), 'Juan');
    await tester.enterText(fields.at(1), 'juan@email.com');

    await tester.pump();

    // Guardar usuario (botón en AppBar)
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Abrir lista de usuarios
    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();

    // Verificar que aparece el usuario
    expect(find.text('Juan'), findsOneWidget);
    expect(find.text('juan@email.com'), findsOneWidget);
  });
}