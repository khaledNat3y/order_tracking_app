import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constants/constants.dart';
import '../model/order_model.dart';

class OrdersRepo {
  final FirebaseFirestore firestore;

  OrdersRepo(this.firestore);


  Future<Either<String, String>> addOrder({required OrderModel orderModel}) async {
    try {
      await firestore
          .collection(FirebaseConstants.ordersCollection)
          .doc()
          .set(orderModel.toJson());
      return const Right("Order Created Successfully");
    }catch (e) {
      log("Error when creating Order: $e");
      return Left("Error When Adding Order: $e");
    }
  }

}
