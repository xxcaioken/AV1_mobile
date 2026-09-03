import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:av1_mobile/main.dart';

void main() {
  void ajustarTela(WidgetTester tester) {
    tester.view.physicalSize = const Size(430, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('estado inicial: cartao bloqueado, USD destacado, sem sucesso',
      (tester) async {
    ajustarTela(tester);
    await tester.pumpWidget(const MaterialApp(home: TelaAtivacaoCartao()));
    expect(find.text('BLOQUEADO'), findsOneWidget);
    expect(find.text('ATIVO'), findsNothing);
    expect(find.text('Cartão configurado com sucesso!'), findsNothing);
    expect(find.text('USD (\$)'), findsOneWidget);
  });

  testWidgets('CVV inicia oculto e alterna com o icone', (tester) async {
    ajustarTela(tester);
    await tester.pumpWidget(const MaterialApp(home: TelaAtivacaoCartao()));
    TextField campo = tester.widget(find.byType(TextField).first);
    expect(campo.obscureText, isTrue);
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();
    campo = tester.widget(find.byType(TextField).first);
    expect(campo.obscureText, isFalse);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets('botao +R\$100 incrementa o limite atual', (tester) async {
    ajustarTela(tester);
    await tester.pumpWidget(const MaterialApp(home: TelaAtivacaoCartao()));
    expect(find.text('500'), findsOneWidget);
    await tester.tap(find.text('+ R\$ 100'));
    await tester.pump();
    expect(find.text('600'), findsOneWidget);
    await tester.tap(find.text('+ R\$ 100'));
    await tester.pump();
    expect(find.text('700'), findsOneWidget);
  });

  testWidgets('selecao de moeda muda o destaque', (tester) async {
    ajustarTela(tester);
    await tester.pumpWidget(const MaterialApp(home: TelaAtivacaoCartao()));
    await tester.tap(find.text('EUR (€)'));
    await tester.pump();
    final Text txt = tester.widget(find.text('EUR (€)'));
    expect(txt.style!.color, Colors.white);
    expect(txt.style!.fontWeight, FontWeight.bold);
  });

  testWidgets('CVV com menos de 3 digitos exibe erro', (tester) async {
    ajustarTela(tester);
    await tester.pumpWidget(const MaterialApp(home: TelaAtivacaoCartao()));
    await tester.enterText(find.byType(TextField).first, '12');
    await tester.tap(find.text('Confirmar e Ativar Cartão'));
    await tester.pump();
    expect(find.text('O CVV deve conter no mínimo 3 dígitos.'), findsOneWidget);
    expect(find.text('BLOQUEADO'), findsOneWidget);
  });

  testWidgets('limite menor que 100 exibe erro', (tester) async {
    ajustarTela(tester);
    await tester.pumpWidget(const MaterialApp(home: TelaAtivacaoCartao()));
    await tester.enterText(find.byType(TextField).first, '123');
    await tester.enterText(find.byType(TextField).last, '50');
    await tester.tap(find.text('Confirmar e Ativar Cartão'));
    await tester.pump();
    expect(find.text('O limite diário não pode ser menor que R\$ 100.'),
        findsOneWidget);
    expect(find.text('BLOQUEADO'), findsOneWidget);
  });

  testWidgets('dados validos ativam o cartao e mostram o resumo',
      (tester) async {
    ajustarTela(tester);
    await tester.pumpWidget(const MaterialApp(home: TelaAtivacaoCartao()));
    await tester.enterText(find.byType(TextField).first, '123');
    await tester.tap(find.text('GBP (£)'));
    await tester.pump();
    await tester.tap(find.text('Confirmar e Ativar Cartão'));
    await tester.pump();
    expect(find.text('ATIVO'), findsOneWidget);
    expect(find.text('BLOQUEADO'), findsNothing);
    expect(find.text('Cartão configurado com sucesso!'), findsOneWidget);
    expect(find.text('Destino GBP com limite de R\$ 500/dia.'), findsOneWidget);
  });
}
