import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/component/healthify_text_field.dart';

import 'test_app.dart';

void main() {
  testWidgets('shows label, placeholder and supporting text', (tester) async {
    await pumpThemed(
      tester,
      HealthifyTextField(
        value: '',
        onChanged: (_) {},
        label: 'Correo',
        placeholder: 'nombre@correo.com',
        supportingText: 'Usa tu correo profesional',
      ),
    );

    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('nombre@correo.com'), findsOneWidget);
    expect(find.text('Usa tu correo profesional'), findsOneWidget);
  });

  testWidgets('reports typed text', (tester) async {
    String? typed;
    await pumpThemed(tester, HealthifyTextField(value: '', onChanged: (v) => typed = v, label: 'Nombre'));

    await tester.enterText(find.byType(TextField), 'Ana');

    expect(typed, 'Ana');
  });

  testWidgets('follows the value pushed by the parent', (tester) async {
    Widget field(String value) => HealthifyTextField(value: value, onChanged: (_) {}, label: 'Nombre');
    await pumpThemed(tester, field('Ana'));

    await pumpThemed(tester, field('Luis'));

    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'Luis');
  });

  testWidgets('error text replaces the supporting text and flags the error state', (tester) async {
    await pumpThemed(
      tester,
      HealthifyTextField(
        value: '',
        onChanged: (_) {},
        label: 'Correo',
        supportingText: 'Ayuda',
        errorText: 'Correo inválido',
      ),
    );

    expect(find.text('Correo inválido'), findsOneWidget);
    expect(find.text('Ayuda'), findsNothing);
  });

  testWidgets('password field masks the text until the eye button is tapped', (tester) async {
    await pumpThemed(
      tester,
      HealthifyTextField(value: 'secreto', onChanged: (_) {}, label: 'Contraseña', type: HealthifyTextFieldType.password),
    );
    bool obscured() => tester.widget<TextField>(find.byType(TextField)).obscureText;

    expect(obscured(), isTrue);
    await tester.tap(find.bySemanticsLabel('Mostrar contraseña'));
    await tester.pump();

    expect(obscured(), isFalse);
    expect(find.bySemanticsLabel('Ocultar contraseña'), findsOneWidget);
  });
}
