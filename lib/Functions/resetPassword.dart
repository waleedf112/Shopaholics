import 'package:firebase_auth/firebase_auth.dart';

Future<void> resetPassword({String email}) => FirebaseAuth.instance.sendPasswordResetEmail(email: email);
