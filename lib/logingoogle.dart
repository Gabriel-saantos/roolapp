import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '894766207106-cb8fcevccqvvickvnd48d80eithm4sqr.apps.googleusercontent.com',
  );

  Future<User?> signInWithGoogle() async {
    User? user;
    try {
      print("Tentando login no Mobile...");
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print("Usuário cancelou o login.");
        return null;
      }
      print("Login do Google bem-sucedido.");
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      user = authResult.user;

      if (user != null) {
        print("Usuário autenticado com sucesso: ${user.uid}");
        await _saveUserInfoToFirestore(user);
      }
    } catch (error) {
      print("Erro de login com o Google: $error");
      return null;
    }

    return user;
  }

  Future<void> _saveUserInfoToFirestore(User user) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = usersCollection.doc(user.uid);
    final existingData = (await userDoc.get()).data();

    print("Salvando informações do usuário no Firestore...");
    Map<String, dynamic> userDataToUpdate = {
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'biography': "",
      'link': "",
    };

    if (existingData != null) {
      userDataToUpdate.forEach((key, value) {
        if (existingData[key] == null || existingData[key].isEmpty) {
          existingData[key] = value;
        }
      });
    }

    await userDoc.set(existingData ?? userDataToUpdate);
    print("Informações do usuário salvas com sucesso.");
  }
}
