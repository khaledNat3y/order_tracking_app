import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/constants.dart';
import '../models/user_model.dart';

class AuthRepo {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepo(this.firebaseAuth, this.firestore);

  Future<Either<String, String>> registerUser({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(credential.user!.uid)
          .set({
            'userName': userName,
            'email': email,
            'uid': credential.user!.uid,
          });
      return const Right("Account Created Successfully");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return const Left("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        return const Left("The account already exists for that email.");
      } else {
        log("Error when creating account: $e");
        return Left("Error When Creating Account: $e");
      }
    } catch (e) {
      log("Error when creating account: $e");
      return Left("Error When Creating Account: $e");
    }
  }

  Future<Either<String, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

       final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore
              .collection(FirebaseConstants.usersCollection)
              .where("uid", isEqualTo: credential.user!.uid)
              .get();
      final userData = querySnapshot.docs.first.data();
      final user = UserModel.fromJson(userData);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        return const Left("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        return const Left("Wrong password provided for that user.");
      } else {
        log("Error when Login: $e");
        return Left("Error When Login: $e");
      }
    } catch (e) {
      log("Error when Login: $e");
      return Left("Unknown Error When Login: $e");
    }
  }
}
