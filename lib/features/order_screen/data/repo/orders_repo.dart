import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/constants.dart';
import '../model/order_model.dart';

class OrdersRepo {
  final FirebaseFirestore firestore;

  OrdersRepo(this.firestore);

  Future<Either<String, String>> addOrder({required OrderModel orderModel,}) async {
    try {
      await firestore
          .collection(FirebaseConstants.ordersCollection)
          .doc()
          .set(orderModel.toJson());
      return const Right("Order Created Successfully");
    } catch (e) {
      log("Error when creating Order: $e");
      return Left("Error When Adding Order: $e");
    }
  }

  Future<Either<String, List<OrderModel>>> getOrders() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore
              .collection(FirebaseConstants.ordersCollection)
              .where(
                "orderUserId",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .get();
      final orders =
          querySnapshot.docs
              .map((order) => OrderModel.fromJson(order.data()))
              .toList();
      return Right(orders);
    } catch (e) {
      return Left("Error When Getting Orders: $e");
    }
  }

  Future<Either<String, String>> editUserLocation({required String orderId, required double userLat, required double userLong,}) async {
    try {
      await firestore
          .collection(FirebaseConstants.ordersCollection)
          .where("orderId", isEqualTo: orderId).get().then((value) {
            value.docs.first.reference.update({
              "userLat": userLat,
              "userLong": userLong,
              "orderStatus": "On the way",
            });
          });

      return const Right("User Location Updated Successfully");

    } catch (e) {
      return Left("Error When Editing User Location: $e");
    }
  }

  Future<Either<String, String>> makeStatusDelivered({required String orderId,}) async {
    try {
      await firestore
          .collection(FirebaseConstants.ordersCollection)
          .where("orderId", isEqualTo: orderId).get().then((value) {
        value.docs.first.reference.update({
          "orderStatus": "Delivered",
        });
      });

      return const Right("Changed Order Status Successfully");

    } catch (e) {
      return Left("Error When Changed Order Status: $e");
    }
  }

  Future<Either<String, OrderModel>> getOrderById({required String orderId,}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore
              .collection(FirebaseConstants.ordersCollection)
              .where("orderId", isEqualTo: orderId).get();
      final order = OrderModel.fromJson(querySnapshot.docs.first.data());
      return Right(order);
    } catch (e) {
      return Left("Error When Getting Order by Id: $e");
    }
  }
}
