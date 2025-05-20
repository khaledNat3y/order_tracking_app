import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:order_tracking_app/core/di/dependency_injection.dart';
import 'package:order_tracking_app/firebase_options.dart';
import 'package:order_tracking_app/order_tracking_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupGetIt();
  runApp(OrderTrackingApp());
}


