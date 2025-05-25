import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/routing/app_routes.dart';

import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/app_styles.dart';
import '../../../../core/widgets/primay_button_widget.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../data/model/order_model.dart';

class CustomOrderWidget extends StatefulWidget {
  final OrderModel orderModel;

  const CustomOrderWidget({super.key, required this.orderModel});

  @override
  State<CustomOrderWidget> createState() => _CustomOrderWidgetState();
}

class _CustomOrderWidgetState extends State<CustomOrderWidget> {
  bool isStarted = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: #${widget.orderModel.orderId}",
              style: AppStyles.black24BoldStyle,
            ),
            const HeightSpace(8),
            Text(
              "Order Name: ${widget.orderModel.orderName}",
              style: AppStyles.black15BoldStyle,
            ),
            const HeightSpace(8),
            Text.rich(
              TextSpan(
                text: "Order Arrival Date: ",
                style: AppStyles.black15BoldStyle,
                children: [
                  TextSpan(
                    text: "${widget.orderModel.orderStatus}",
                    style: AppStyles.red15BoldStyle,
                  ),
                ],
              ),
            ),
            const HeightSpace(8),
            Text(
              "Order Status: ${widget.orderModel.orderDate}",
              style: AppStyles.black15BoldStyle,
            ),
            const HeightSpace(16),
            PrimaryButtonWidget(
              buttonText: "Start Order",
              onPress: () {
                GoRouter.of(context).pushNamed(
                  AppRoutes.orderTrackScreen,
                  extra: widget.orderModel,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
