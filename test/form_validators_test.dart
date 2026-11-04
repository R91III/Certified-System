import 'package:flutter_test/flutter_test.dart';
import 'package:certified_system/utils/form_validators.dart';

void main() {
  group('FormValidators', () {
    test('validates login identifier and password minimums', () {
      expect(FormValidators.identifier('1234'), isNotNull);
      expect(FormValidators.identifier('12345'), isNull);
      expect(FormValidators.identifier('student@university'), isNotNull);
      expect(FormValidators.identifier('student@university.edu'), isNull);
      expect(FormValidators.loginPassword('12345'), isNotNull);
      expect(FormValidators.loginPassword('123456'), isNull);
    });

    test('validates academic ID and university email formats', () {
      expect(FormValidators.academicId('12345678'), isNotNull);
      expect(FormValidators.academicId('123456789'), isNull);
      expect(FormValidators.academicId('12345678901'), isNotNull);
      expect(FormValidators.email('student.example'), isNotNull);
      expect(FormValidators.email('student@university.edu'), isNull);
    });

    test('requires a strong password and exact confirmation', () {
      expect(FormValidators.strongPassword('password1'), isNotNull);
      expect(FormValidators.strongPassword('Student1'), isNull);
      expect(FormValidators.confirmPassword('Student2', 'Student1'), isNotNull);
      expect(FormValidators.confirmPassword('Student1', 'Student1'), isNull);
    });

    test('accepts only six numeric OTP digits', () {
      expect(FormValidators.otp('12345'), isNotNull);
      expect(FormValidators.otp('12345a'), isNotNull);
      expect(FormValidators.otp('123456'), isNull);
    });
  });
}
