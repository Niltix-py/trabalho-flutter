import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meus_livros/main.dart';

/// Rola até o botão Salvar (pode estar fora da tela) e toca nele.
Future<void> tapSave(WidgetTester tester) async {
  final save = find.byKey(const Key('saveButton'));
  await tester.ensureVisible(save);
  await tester.pumpAndSettle();
  await tester.tap(save);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('estado vazio, validação e criação de livro', (tester) async {
    await tester.pumpWidget(const MeusLivrosApp());

    // Estado vazio.
    expect(find.text('Nenhum livro ainda'), findsOneWidget);

    // Abre o formulário e tenta salvar vazio: mostra erros e continua nele.
    await tester.tap(find.byKey(const Key('addButton')));
    await tester.pumpAndSettle();
    await tapSave(tester);
    expect(find.text('Informe o título (mínimo 2 caracteres).'), findsOneWidget);
    expect(find.text('Informe o autor (mínimo 2 caracteres).'), findsOneWidget);
    expect(find.text('Novo livro'), findsOneWidget);

    // Preenche e salva: o formulário fecha e o livro aparece na lista.
    await tester.enterText(find.byKey(const Key('titleField')), 'Dom Casmurro');
    await tester.enterText(find.byKey(const Key('authorField')), 'Machado de Assis');
    await tapSave(tester);

    expect(find.text('Novo livro'), findsNothing);
    expect(find.text('Nenhum livro ainda'), findsNothing);
    expect(find.text('Dom Casmurro'), findsOneWidget);
    // Este texto só existe no item da lista (autor · status).
    expect(find.text('Machado de Assis · Quero ler'), findsOneWidget);
  });

  testWidgets('edição atualiza o item na lista', (tester) async {
    await tester.pumpWidget(const MeusLivrosApp());

    await tester.tap(find.byKey(const Key('addButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('titleField')), 'Dom Casmurro');
    await tester.enterText(find.byKey(const Key('authorField')), 'Machado de Assis');
    await tapSave(tester);

    // Detalhe -> editar -> novo título.
    await tester.tap(find.text('Dom Casmurro'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('editButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('titleField')), 'Quincas Borba');
    await tapSave(tester);
    expect(find.text('Editar livro'), findsNothing);
    expect(find.text('Quincas Borba'), findsWidgets);

    // Volta para a lista: o título novo aparece e o antigo não.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Quincas Borba'), findsOneWidget);
    expect(find.text('Dom Casmurro'), findsNothing);
  });
}