import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/navigation/ui/presentation/widgets/main_bottom_nav.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Montserrat')
      ..addFont(
        rootBundle.load('assets/fonts/montserrat/Montserrat-Variable.ttf'),
      );
    await font.load();
  });

  for (final (index, label, x, width, icon) in [
    (0, 'EXPLORE', 30.0, 155.0, 'search'),
    (1, 'FAVOURITE', 110.0, 165.0, 'favourite'),
    (2, 'MENU', 217.0, 128.0, 'menu'),
  ]) {
    testWidgets('геометрия $label соответствует компоненту 375 × 100', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(375, 100);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      var selected = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: MainBottomNav(
            selectedIndex: index,
            onSelected: (value) => selected = value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(label), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      final capsule = find.ancestor(
        of: find.text(label),
        matching: find.byType(Material),
      );
      expect(tester.getRect(capsule), Rect.fromLTWH(x, 25, width, 50));
      final image = find.image(AssetImage('assets/icons/bottom_nav/$icon.png'));
      expect(tester.getRect(image), Rect.fromLTWH(x + 20, 35, 30, 30));
      expect(tester.widget<Material>(capsule).color, Colors.white);
      await tester.tap(find.byTooltip('Профиль'));
      expect(selected, 2);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'узкий экран учитывает системный отступ и позволяет выбрать каждую вкладку',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 150);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      var selected = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(bottom: 34),
              textScaler: TextScaler.linear(2),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: MainBottomNav(
                selectedIndex: 1,
                onSelected: (value) => selected = value,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(MainBottomNav)).height, 109);
      for (final (label, index) in [
        ('Главная', 0),
        ('Все новости', 1),
        ('Профиль', 2),
      ]) {
        expect(
          tester.getSize(find.byTooltip(label)).width,
          greaterThanOrEqualTo(48),
        );
        await tester.tap(find.byTooltip(label));
        expect(selected, index);
      }
      expect(tester.takeException(), isNull);
    },
  );
}
