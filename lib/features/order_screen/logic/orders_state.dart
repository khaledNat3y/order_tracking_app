part of 'orders_cubit.dart';

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class AddingOrderStatus extends OrdersState {}

final class SuccessAddingOrder extends OrdersState {
  final String successMessage;

  SuccessAddingOrder({required this.successMessage});
}

final class ErrorAddingOrder extends OrdersState {
  final String errorMessage;

  ErrorAddingOrder({required this.errorMessage});
}
final class GettingOrderStatus extends OrdersState {}

final class SuccessGettingOrder extends OrdersState {
  final List<OrderModel> ordersList;

  SuccessGettingOrder({required this.ordersList});
}

final class ErrorGettingOrder extends OrdersState {
  final String errorMessage;

  ErrorGettingOrder({required this.errorMessage});
}

final class OrderDeliveredStatus extends OrdersState {
  final String message;

  OrderDeliveredStatus({required this.message});
}


final class GettingOneOrderStatus extends OrdersState {}

final class ErrorGettingOneOrder extends OrdersState {
  final String errorMessage;

  ErrorGettingOneOrder({required this.errorMessage});
}

final class SuccessGettingOneOrder extends OrdersState {
  final OrderModel order;

  SuccessGettingOneOrder({required this.order});
}

