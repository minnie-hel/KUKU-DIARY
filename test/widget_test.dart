import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kuku_diary/main.dart';
import 'package:kuku_diary/providers/app_state.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const KukuDiaryApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(KukuDiaryApp), findsOneWidget);
  });
}
