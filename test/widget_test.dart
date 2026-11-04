// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:certified_system/controllers/auth_controller.dart';
import 'package:certified_system/main.dart';
import 'package:certified_system/repositories/auth_repository_impl.dart';

Widget createApp() =>
    CertifiedSystemApp(controller: AuthController(AuthRepositoryImpl()));

void main() {
  testWidgets('shows the student login form', (WidgetTester tester) async {
    await tester.pumpWidget(createApp());
    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('المعرف الأكاديمي أو البريد'), findsOneWidget);
    expect(find.text('تذكرني'), findsOneWidget);
  });

  testWidgets('validates required login fields', (WidgetTester tester) async {
    await tester.pumpWidget(createApp());
    await tester.tap(find.widgetWithText(FilledButton, 'تسجيل الدخول'));
    await tester.pump();
    expect(find.text('هذا الحقل مطلوب'), findsOneWidget);
    expect(find.text('كلمة المرور مطلوبة'), findsOneWidget);
  });
}
