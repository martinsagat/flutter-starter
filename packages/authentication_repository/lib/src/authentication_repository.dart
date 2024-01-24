import 'dart:async';
import 'package:dio/dio.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final Dio _dio = Dio();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      // Make a real authentication request to your backend
      // Replace the URL with your actual authentication endpoint
      final response = await _dio.post(
        'http://192.168.0.27:8000/auth/login',
        data: {'email': email, 'password': password},
      );

      // Check the response status and update authentication status accordingly
      if (response.statusCode == 200) {
        _controller.add(AuthenticationStatus.authenticated);
      } else {
        _controller.addError('Authentication failed');
      }
    } catch (error) {
      // Handle errors, e.g., network errors, server errors
      _controller.addError('Authentication failed: $error');
    }
  }

  void logOut() {
    // Perform any necessary cleanup or backend calls for logout
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _controller.close();
  }
}
