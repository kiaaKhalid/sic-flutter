import 'dart:async';

class AuthRepository {
  // TODO: Replace stubs with real API calls (HTTP/Firebase/etc.)
  Future<void> sendLoginCode({required String email}) async {
    // Simulate API latency
    await Future.delayed(const Duration(milliseconds: 800));
    // Here you would call your backend to send a 6-digit/char code to [email]
  }

  Future<bool> verifyLoginCode({required String email, required String code}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Replace with real verification logic. For now accept any 6-length code.
    return code.length == 6;
  }
}
