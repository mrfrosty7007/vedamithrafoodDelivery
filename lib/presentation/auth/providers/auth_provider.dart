import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/models/user_model.dart';
import '../../../core/constants/firebase_constants.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService = FirestoreService();

  AuthStatus _status = AuthStatus.initial;
  String? _verificationId;
  ConfirmationResult? _confirmationResult;
  String? _errorMessage;
  UserModel? _currentUserModel;
  String _userRole = '';

  AuthProvider(this._authService) {
    _checkAuthState();
  }

  // Getters
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUserModel => _currentUserModel;
  String get userRole => _userRole;
  User? get firebaseUser => _authService.currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // ---------- Auth State Listener ----------

  void _checkAuthState() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        await _loadUserData(user.uid);
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        _currentUserModel = null;
        _userRole = '';
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    final data = await _firestoreService.getUser(uid);
    if (data != null) {
      _currentUserModel = UserModel.fromMap(data);
      _userRole = _currentUserModel!.role;
    }
  }

  // ---------- Phone OTP (Customer) ----------

Future<void> sendOtp(String phoneNumber) async {
  _status = AuthStatus.loading;
  _errorMessage = null;
  notifyListeners();

  try {
    final result = await _authService.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        _verificationId = verificationId;
      },
      onError: (error) {
        _errorMessage = error;
      },
    );

    if (result != null) {
      // This is WEB case
      _confirmationResult = result;
    }

    _status = AuthStatus.unauthenticated;
    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    _status = AuthStatus.error;
    notifyListeners();
  }
}

Future<bool> verifyOtp(String otp) async {
  _status = AuthStatus.loading;
  _errorMessage = null;
  notifyListeners();

  try {
    final credential = await _authService.verifyOtp(
      verificationId: _verificationId,
      otp: otp,
      confirmationResult: _confirmationResult,
    );

    final user = credential?.user;

    if (user != null) {
      final existingUser =
          await _firestoreService.getUser(user.uid);

      if (existingUser == null) {
        final newUser = UserModel(
          uid: user.uid,
          phone: user.phoneNumber ?? '',
          name: '',
          role: FirebaseConstants.roleCustomer,
          createdAt: DateTime.now(),
        );

        await _firestoreService.createUser(
            user.uid, newUser.toMap());

        _currentUserModel = newUser;
      } else {
        _currentUserModel =
            UserModel.fromMap(existingUser);
      }

      _userRole = _currentUserModel!.role;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }

    return false;
  } catch (e) {
    _errorMessage = e.toString();
    _status = AuthStatus.error;
    notifyListeners();
    return false;
  }
}


  // ---------- Email / Password (Owner) ----------

  Future<bool> ownerLogin(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await _loadUserData(user.uid);
        if (_userRole != FirebaseConstants.roleOwner) {
          _errorMessage = 'This account is not an owner account';
          await _authService.signOut();
          _status = AuthStatus.error;
          notifyListeners();
          return false;
        }
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login failed';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // ---------- Sign Out ----------

  Future<void> signOut() async {
    await _authService.signOut();
    _status = AuthStatus.unauthenticated;
    _currentUserModel = null;
    _userRole = '';
    _verificationId = null;
    notifyListeners();
  }
}
