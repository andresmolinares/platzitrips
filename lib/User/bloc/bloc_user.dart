import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platzi_trips_app/User/model/user.dart' as userModel;
import 'package:platzi_trips_app/User/repository/cloud_firestore_repository.dart';
class UserBloc implements Bloc{
  final _auth_repository = AuthRepository();
  //Flujo de datos - Stream
  //Stream - Firebase
  Stream<User?> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User?> get authStatus => streamFirebase;


  //Casos uso
  //1. SignIn a la aplicacion de Google
  Future<UserCredential> signIn(){
  return _auth_repository.signInFirebase();
  }
  //2. Registrar usuario en la bd
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(userModel.User user) => _cloudFirestoreRepository.updateUserDataFirestore(user);
  signOut(){
    _auth_repository.signOut();
  }
  @override
  void dispose() {
    // TODO: implement dispose
  }

}