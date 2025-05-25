import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracking_app/features/order_screen/logic/orders_cubit.dart';
import 'package:order_tracking_app/features/order_screen/ui/widgets/custom_order_widget.dart';
import '../../../core/styling/app_colors.dart';
import '../../../core/styling/app_styles.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("My Orders", style: AppStyles.white24BoldStyle),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.sp),
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is GettingOrderStatus) {
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
            if (state is ErrorGettingOrder) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is SuccessGettingOrder) {
              log("state is SuccessGettingOrder");
              return RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: (){
                  return context.read<OrdersCubit>().getOrders();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.ordersList.length,
                        itemBuilder: (context, index) {
                          return CustomOrderWidget(
                            orderModel: state.ordersList[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}


