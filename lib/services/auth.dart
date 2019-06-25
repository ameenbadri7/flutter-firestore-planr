import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final AuthService _instance = AuthService.internal();

  factory AuthService() => _instance;

  AuthService.internal();

  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> signIn(email, password) async {
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<FirebaseUser> signUp(email, password) async {
    try {
      FirebaseUser user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> signOut() {
    print('signing out');
    return _auth.signOut();
  }
}
