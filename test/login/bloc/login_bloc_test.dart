import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      final loginBloc = LoginBloc(
        authenticationRepository: authenticationRepository,
      );
      expect(loginBloc.state, const LoginState());
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when login succeeds',
        setUp: () {
          when(
            () => authenticationRepository.logIn(
              email: 'email',
              password: 'password',
            ),
          ).thenAnswer((_) => Future<String>.value('user'));
        },
        build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('email'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(email: Email.dirty('email')),
          LoginState(
            email: Email.dirty('email'),
            password: Password.dirty('password'),
            isValid: true,
          ),
          LoginState(
            email: Email.dirty('email'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            email: Email.dirty('email'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginInProgress, LoginFailure] when logIn fails',
        setUp: () {
          when(
            () => authenticationRepository.logIn(
              email: 'email',
              password: 'password',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('email'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            email: Email.dirty('email'),
          ),
          LoginState(
            email: Email.dirty('email'),
            password: Password.dirty('password'),
            isValid: true,
          ),
          LoginState(
            email: Email.dirty('email'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            email: Email.dirty('email'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
          ),
        ],
      );
    });
  });
}
