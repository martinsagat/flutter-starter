// ignore_for_file: prefer_const_constructors
import 'package:flutter_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const emailString = 'mock-email';
  group('Email', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        final email = Email.pure();
        expect(email.value, '');
        expect(email.isPure, isTrue);
      });

      test('dirty creates correct instance', () {
        final email = Email.dirty(emailString);
        expect(email.value, emailString);
        expect(email.isPure, isFalse);
      });
    });

    group('validator', () {
      test('returns empty error when email is empty', () {
        expect(
          Email.dirty().error,
          EmailValidationError.empty,
        );
      });

      test('is valid when email is not empty', () {
        expect(
          Email.dirty(emailString).error,
          isNull,
        );
      });
    });
  });
}
