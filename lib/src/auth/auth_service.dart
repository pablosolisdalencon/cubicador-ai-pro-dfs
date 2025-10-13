import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream para escuchar los cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Iniciar sesión con email y contraseña
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Manejar errores, por ejemplo, usuario no encontrado o contraseña incorrecta
      print(e.message);
      return null;
    }
  }

  // Registrar un nuevo usuario con email y contraseña
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Manejar errores, por ejemplo, el email ya está en uso
      print(e.message);
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
