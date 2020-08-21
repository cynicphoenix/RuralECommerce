import 'package:firebase_auth/firebase_auth.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Extract UID from firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  } 

  // Auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
  }

  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseServices (uid: user.uid).updateUserData('', '', false, '', '', false);
      return _userFromFirebaseUser(user);
    }
    catch(error) {
      print(error.toString());
      return null;
    } 
  }

  // SignIn with Google
  Future signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      
      if(authResult.additionalUserInfo.isNewUser){
        await DatabaseServices (uid: user.uid).updateUserData('', '', false, '', '', false);
      }

      return _userFromFirebaseUser(user);
    }
    catch(error) {
      print(error.toString());
      return null;
    } 
  }

  // Sign In with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(error) {
      print(error.toString());
      return null;
    } 
  } 

  // SignIn with Google


  // Sign Out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(error) {
      print(error.toString());
      return null;
    }

  }
}