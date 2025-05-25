import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking_app/features/order_screen/logic/orders_cubit.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/styling/app_assets.dart';
import '../../../core/styling/app_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primay_button_widget.dart';
import '../../../core/widgets/spacing_widgets.dart';

class SearchMyOrderScreen extends StatefulWidget {
  const SearchMyOrderScreen({super.key});

  @override
  State<SearchMyOrderScreen> createState() => _SearchMyOrderScreenState();
}

class _SearchMyOrderScreenState extends State<SearchMyOrderScreen> {
  bool isPassword = false;
  final formKey = GlobalKey<FormState>();
  late TextEditingController orderId;

  @override
  void initState() {
    super.initState();

    orderId = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is ErrorGettingOneOrder) {
              showAnimatedSnackDialog(
                context,
                message: state.errorMessage,
                type: AnimatedSnackBarType.error,
              );
            }
            if (state is SuccessGettingOneOrder) {
              FirebaseFirestore.instance;
              showAnimatedSnackDialog(
                context,
                message: "Success",
                type: AnimatedSnackBarType.success,
              );
              context.push(
                AppRoutes.trackMyOrderUserMap,
                extra: state.order,
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(28),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Track Your Order",
                        style: AppStyles.primaryHeadLinesStyle,
                      ),
                    ),
                    const HeightSpace(8),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "it's great to see you again",
                        style: AppStyles.grey12MediumStyle,
                      ),
                    ),
                    const HeightSpace(20),
                    Center(
                      child: Image.asset(
                        AppAssets.order,
                        width: 190.w,
                        height: 190.w,
                      ),
                    ),
                    const HeightSpace(32),
                    Text("Order ID", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: orderId,
                      hintText: "Enter by Order ID",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Order ID";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(55),
                    BlocBuilder<OrdersCubit, OrdersState>(
                      builder: (context, state) {
                        return PrimaryButtonWidget(
                          buttonText:
                              state is GettingOneOrderStatus
                                  ? "Loading..."
                                  : "Search",
                          onPress:
                              state is GettingOneOrderStatus
                                  ? () {}
                                  : () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<OrdersCubit>().getOrderById(
                                        orderId: orderId.text,
                                      );
                                    }
                                  },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
