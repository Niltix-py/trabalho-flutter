import 'package:flutter_test/flutter_test.dart';
import 'package:meus_livros/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('estado vazio, validação e criação de livro', (tester) async {
    await tester.pumpWidget(const MeusLivrosApp());

    // Estado vazio.
    expect(find.text('Nenhum livro ainda'), findsOneWidget);

    // Abre o formulário e tenta salvar vazio: mostra erros.
    await tester.tap(find.byKey(const Key('addButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();
    expect(find.text('Informe o título (mínimo 2 caracteres).'), findsOneWidget);
    expect(find.text('Informe o autor (mínimo 2 caracteres).'), findsOneWidget);

    // Preenche e salva: o livro aparece na lista.
    await tester.enterText(find.byKey(const Key('titleField')), 'Dom Casmurro');
    await tester.enterText(find.byKey(const Key('authorField')), 'Machado de Assis');
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum livro ainda'), findsNothing);
    expect(find.text('Dom Casmurro'), findsOneWidget);
  });

  testWidgets('edição atualiza o item na lista', (tester) async {
    await tester.pumpWidget(const MeusLivrosApp());

    await tester.tap(find.byKey(const Key('addButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('titleField')), 'Dom Casmurro');
    await tester.enterText(find.byKey(const Key('authorField')), 'Machado de Assis');
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    // Detalhe -> editar -> novo título.
    await tester.tap(find.text('Dom Casmurro'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('editButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('titleField')), 'Quincas Borba');
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();
    expect(find.text('Quincas Borba'), findsWidgets);

    // Volta para a lista: o título novo aparece e o antigo não.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Quincas Borba'), findsOneWidget);
    expect(find.text('Dom Casmurro'), findsNothing);
  });
}
