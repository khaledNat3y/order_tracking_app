import 'package:flutter/material.dart';

import 'features/home/ui/home_screen.dart';

class OrderTrackingApp extends StatelessWidget {
  const OrderTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
