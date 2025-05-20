class OrderModel {
  String? orderId;
  String? orderName;
  double? orderLat;
  double? orderLong;
  double? userLat;
  double? userLong;
  String? orderUserId;
  String? orderDate;
  String? orderStatus;

  OrderModel({
    this.orderId,
    this.orderName,
    this.orderLat,
    this.orderLong,
    this.userLat,
    this.userLong,
    this.orderUserId,
    this.orderDate,
    this.orderStatus,
  });
  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderName = json['orderName'];
    orderLat = json['orderLat'];
    orderLong = json['orderLong'];
    userLat = json['userLat'];
    userLong = json['userLong'];
    orderUserId = json['orderUserId'];
    orderDate = json['orderDate'];
    orderStatus = json['orderStatus'];
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderName': orderName,
      'orderLat': orderLat,
      'orderLong': orderLong,
      'userLat': userLat,
      'userLong': userLong,
      'orderUserId': orderUserId,
      'orderDate': orderDate,
      'orderStatus': orderStatus,
    };
  }

}

/// order id
/// order name
/// order lat
/// order long
/// user lat
/// user long
/// order user id
/// order date
/// order status
