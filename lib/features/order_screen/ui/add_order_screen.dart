import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:order_tracking_app/core/routing/app_routes.dart';
import 'package:order_tracking_app/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking_app/features/order_screen/logic/orders_cubit.dart';

import '../../../core/styling/app_assets.dart';
import '../../../core/styling/app_colors.dart';
import '../../../core/styling/app_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primay_button_widget.dart';
import '../../../core/widgets/spacing_widgets.dart';
import '../data/model/order_model.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController orderIdController;
  late TextEditingController orderNameController;
  late TextEditingController orderArrivalDateController;
  LatLng? orderLocation;
  LatLng? userLocation;
  DateTime? orderArrivalDate;
  String orderLocationDetails = "";

  @override
  void initState() {
    super.initState();
    orderIdController = TextEditingController();
    orderNameController = TextEditingController();
    orderArrivalDateController = TextEditingController();
  }

  @override
  void dispose() {
    orderIdController.dispose();
    orderNameController.dispose();
    orderArrivalDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Add Order", style: AppStyles.white24BoldStyle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is SuccessAddingOrder) {
              showAnimatedSnackDialog(
                context,
                message: state.successMessage,
                type: AnimatedSnackBarType.success,
              );
              orderIdController.clear();
              orderNameController.clear();
              orderArrivalDateController.clear();
              orderArrivalDate = null;
              orderLocation = null;
            }
            if (state is ErrorAddingOrder) {
              showAnimatedSnackDialog(
                context,
                message: state.errorMessage,
                type: AnimatedSnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is AddingOrderStatus) {
              return SizedBox.expand(
                child: Center(
                  child: SizedBox(
                    width: 40.sp,
                    height: 40.sp,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              );
            }
            return Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(28),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Create Your New Order",
                        style: AppStyles.primaryHeadLinesStyle,
                      ),
                    ),
                    const HeightSpace(8),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Let's create your order.",
                        style: AppStyles.grey12MediumStyle,
                      ),
                    ),
                    const HeightSpace(20),
                    Center(
                      child: Image.asset(
                        AppAssets.logo,
                        width: 190.w,
                        height: 190.w,
                      ),
                    ),
                    const HeightSpace(32),
                    Text("Order ID", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: orderIdController,
                      hintText: "Enter Your Order ID",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Order ID";
                        }
                        return null;
                      },
                    ),
                    HeightSpace(16),
                    Text("Order Name", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: orderNameController,
                      hintText: "Enter Your Order Name",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Order Name";
                        }
                        return null;
                      },
                    ),
                    HeightSpace(16),
                    Text("Arrival Date", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      readOnly: true,
                      controller: orderArrivalDateController,
                      hintText: "Enter Your Arrival Date",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Arrival Date";
                        }
                        return null;
                      },
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        ).then((value) {
                          setState(() {
                            orderArrivalDate = value;
                            if (orderArrivalDate != null) {
                              String dateFormatted = DateFormat(
                                "yyyy-MM-dd",
                              ).format(orderArrivalDate!);

                              orderArrivalDateController.text = dateFormatted;
                            }
                          });
                        });
                      },
                    ),
                    HeightSpace(16),
                    PrimaryButtonWidget(
                      buttonText: "Select Order Location",
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onPress: () async {
                        orderLocation = await context.push<LatLng?>(
                          AppRoutes.placePickerScreen,
                        );
                        log(orderLocation.toString());
                      },
                    ),
                    HeightSpace(16),
                    orderLocation != null
                        ? Text(
                          "$orderLocation",
                          style: AppStyles.black16w500Style,
                        )
                        : SizedBox.shrink(),
                    HeightSpace(16),
                    PrimaryButtonWidget(
                      buttonText: "Create Order",
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          // if (orderLocation == null) {
                          //   showAnimatedSnackDialog(
                          //     context,
                          //     message: "Please select order location",
                          //     type: AnimatedSnackBarType.warning,
                          //   );
                          //   return;
                          // }
                          if (orderArrivalDate == null) {
                            showAnimatedSnackDialog(
                              context,
                              message:
                                  "Please select arrival date of the order",
                              type: AnimatedSnackBarType.warning,
                            );
                            return;
                          }

                          OrderModel orderModel = OrderModel(
                            orderId: orderIdController.text,
                            orderName: orderNameController.text,
                            orderLat: 0.0,
                            orderLong: 0.0,
                            userLat: 0.0,
                            userLong: 0.0,
                            orderUserId: FirebaseAuth.instance.currentUser!.uid,
                            orderDate: DateFormat(
                              "yyyy-MM-dd",
                            ).format(orderArrivalDate!),
                            orderStatus: "Started",
                          );
                          context.read<OrdersCubit>().addOrder(
                            orderModel: orderModel,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
