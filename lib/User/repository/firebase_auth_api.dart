import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential> signIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final user = await _auth.signInWithCredential(GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    ));

    // Once signed in, return the UserCredential
    return user;
  }
  //Metodo para obtener el usuario actualmente logueado
  Future<User?> currentUser() async {
    return _auth.currentUser;
  }
  void signOut() async {
    await googleSignIn.signOut().then((value) => print("Sesion de Google cerrada"));
    await _auth.signOut().then((value) => print("Sesión de Firebase Cerrada"));
  }
}