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
