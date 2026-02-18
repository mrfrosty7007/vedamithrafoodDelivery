import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


/// Service layer wrapping Firebase Authentication.
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ---------- Phone / OTP Auth ----------

  /// Sends an OTP to the given phone number.
  /// [onCodeSent] provides the verificationId needed to verify later.
Future<ConfirmationResult?> sendOtp({
  required String phoneNumber,
  required void Function(String verificationId)? onCodeSent,
  required void Function(String error)? onError,
}) async {
  try {
    if (kIsWeb) {
      // WEB FLOW
      return await _auth.signInWithPhoneNumber('+91$phoneNumber');
    } else {
      // MOBILE FLOW
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError?.call(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent?.call(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return null;
    }
  } catch (e) {
    onError?.call(e.toString());
    return null;
  }
}
  /// Verifies the OTP entered by the user.
Future<UserCredential?> verifyOtp({
  String? verificationId,
  required String otp,
  ConfirmationResult? confirmationResult,
}) async {
  if (kIsWeb) {
    return await confirmationResult!.confirm(otp);
  } else {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );
    return await _auth.signInWithCredential(credential);
  }
}

  // ---------- Email / Password Auth (Owner) ----------

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ---------- Common ----------

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
