import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_tracking_app/features/order_screen/data/model/order_model.dart';
import 'package:order_tracking_app/features/order_screen/data/repo/orders_repo.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo _orderRepo;

  OrdersCubit(this._orderRepo) : super(OrdersInitial());

  Future<void> addOrder({required OrderModel orderModel}) async {
    emit(AddingOrderStatus());
    final result = await _orderRepo.addOrder(orderModel: orderModel);
    result.fold(
      (errorMessage) => emit(ErrorAddingOrder(errorMessage: errorMessage)),
      (successMessage) =>
          emit(SuccessAddingOrder(successMessage: successMessage)),
    );
  }

  Future<void> getOrders() async {
    emit(GettingOrderStatus());
    final result = await _orderRepo.getOrders();
    result.fold(
      (errorMessage) => emit(ErrorGettingOrder(errorMessage: errorMessage)),
      (orders) => emit(SuccessGettingOrder(ordersList: orders)),
    );
  }

  Future<void> editUserLocation({
    required String orderId,
    required double userLat,
    required double userLong,
  }) async {
    emit((GettingOrderStatus()));
    await _orderRepo.editUserLocation(
      orderId: orderId,
      userLat: userLat,
      userLong: userLong,
    );
  }

  Future<void> makeOrderDeliveredStatus({
    required String orderId,
  }) async {
    emit((GettingOrderStatus()));
    final result = await _orderRepo.makeStatusDelivered(
      orderId: orderId,
    );
    result.fold(
      (errorMessage) {

      },
      (successMessage) =>
          emit(OrderDeliveredStatus(message: successMessage)),
    );
  }

  Future<void> getOrderById({required String orderId,}) async {
    emit(GettingOneOrderStatus());
    final result = await _orderRepo.getOrderById(orderId: orderId);
    result.fold(
      (errorMessage) => emit(ErrorGettingOneOrder(errorMessage: errorMessage)),
      (order) => emit(SuccessGettingOneOrder(order: order)),
    );
  }

}
