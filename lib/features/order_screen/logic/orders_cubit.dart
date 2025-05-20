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
}
