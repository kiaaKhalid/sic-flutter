import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  // Optional: paste your Google OAuth Web Client ID here if required.
  static const String kWebClientId = '628022839059-22u0jesqu6mbduuafend273o371q365k.apps.googleusercontent.com'; // e.g. '1234567890-abc.apps.googleusercontent.com'

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kWebClientId,
    scopes: const <String>['email'],
  );

  static Future<void> signIn(BuildContext context) async {
    try {
      GoogleSignInAccount? account;
      if (kIsWeb) {
        account = await _googleSignIn.signInSilently();
      }
      account ??= await _googleSignIn.signIn();
      
      if (!context.mounted) return;
      
      if (account == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled')),
        );
        return;
      }
      
      await account.authentication; // Obtain tokens if you need to send to backend
      
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as ${account.email}')),
      );
      
      // You can now send auth.idToken / auth.accessToken to your backend.
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
      if (kDebugMode) {
        rethrow;
      }
    }
  }
}
