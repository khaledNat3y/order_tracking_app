import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:order_tracking_app/core/styling/app_assets.dart';
import 'package:order_tracking_app/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking_app/core/utils/location_services.dart';
import 'package:order_tracking_app/features/order_screen/data/model/order_model.dart';
import 'package:order_tracking_app/features/order_screen/logic/orders_cubit.dart';

import '../../../core/styling/app_colors.dart';
import '../../../core/styling/app_styles.dart';
import '../../../core/widgets/spacing_widgets.dart';

class OrderTrackMapScreen extends StatefulWidget {
  final OrderModel orderModel;

  const OrderTrackMapScreen({super.key, required this.orderModel});

  @override
  State<OrderTrackMapScreen> createState() => _OrderTrackMapScreenState();
}

class _OrderTrackMapScreenState extends State<OrderTrackMapScreen> {
  ///Custom Info Controller
  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  ///Google Maps Controller
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  ///Initial Camera Position Method
  CameraPosition initialCameraPosition() {
    return CameraPosition(target: LatLng(30.06263, 31.24967), zoom: 14);
  }

  Set<Marker> markers = {};
  LatLng? currentUserLocation;

  getCurrentPositionAndAnimateToIt() async {
    try {
      Position position = await LocationServices.determinePosition();
      currentUserLocation = LatLng(position.latitude, position.longitude);
      _animateToPosition(LatLng(position.latitude, position.longitude));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _animateToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15),
      ),
    );
  }

  loadOrderLocationAndUserMarker() async {
    final Uint8List markerIcon = await LocationServices.getBytesFromAsset(
      AppAssets.order,
      30,
    );
    final Uint8List truckMarkerIcon = await LocationServices.getBytesFromAsset(
      AppAssets.truck,
      30,
    );
    final Marker orderMarker = Marker(
      icon: BitmapDescriptor.bytes(markerIcon),
      markerId: MarkerId(widget.orderModel.orderId!),
      position: LatLng(
          widget.orderModel.orderLat!, widget.orderModel.orderLong!),
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Card(
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
                ],
              ),
            ),
          ),
          LatLng(30.06263, 31.24967),
        );
      },
    );
    final Marker truckMarker = Marker(
      icon: BitmapDescriptor.bytes(truckMarkerIcon),
      markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid),
      position: currentUserLocation ?? LatLng(30.06263, 31.34967),
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Card(
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
                ],
              ),
            ),
          ),
          LatLng(30.06263, 31.24967),
        );
      },
    );

    markers.addAll([orderMarker, truckMarker]);
    setState(() {});
  }

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDykM-3q6e2LqOUcFxGfnN9CtD5hrRDXe4";

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppColors.primaryColor,
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    polylines = {};
    polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleAPiKey,
      request: PolylineRequest(
        origin: PointLatLng(30.06263, 31.24967),
        destination: PointLatLng(30.06263, 31.34967),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.map((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  listenToUserLocation() {
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    ).listen((Position? position) {
      currentUserLocation = LatLng(position!.latitude, position.longitude);
      updateTruckMarkerPoint();
      context.read<OrdersCubit>().editUserLocation(
        orderId: widget.orderModel.orderId!,
        userLat: currentUserLocation!.latitude,
        userLong: currentUserLocation!.longitude,
      );
      _getPolyline();
      checkDistanceBetweenTwoPoints(
          LatLng(position.latitude, position.longitude),
          LatLng(widget.orderModel.orderLat!, widget.orderModel.orderLong!));
    });
  }

  checkDistanceBetweenTwoPoints(LatLng currentLocation, LatLng orderLocation) {
    double distance = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      orderLocation.latitude,
      orderLocation.longitude,
    );
    if (distance < 100) {
      context.read<OrdersCubit>().makeOrderDeliveredStatus(
          orderId: widget.orderModel.orderId!);
    }
    return distance;
  }


  updateTruckMarkerPoint() async {
    final Uint8List truckMarkerIcon = await LocationServices.getBytesFromAsset(
      AppAssets.truck,
      30,
    );
    final Marker truckMarker = Marker(
      icon: BitmapDescriptor.bytes(truckMarkerIcon),
      markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid),
      position: currentUserLocation ?? LatLng(30.06263, 31.34967),
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Card(
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
                ],
              ),
            ),
          ),
          LatLng(30.06263, 31.34967),
        );
      },
    );
    markers.remove(truckMarker);
    markers.add(truckMarker);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    LocationServices.determinePosition();
    listenToUserLocation();
    getLocationThenLoadMarker();
    _getPolyline();
  }

  getLocationThenLoadMarker() async {
    await getCurrentPositionAndAnimateToIt();
    loadOrderLocationAndUserMarker();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderDeliveredStatus) {
          showAnimatedSnackDialog(context, message: state.message,
              type: AnimatedSnackBarType.success);
          context.pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: initialCameraPosition(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _customInfoWindowController.googleMapController = controller;
              },
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              markers: markers,
              polylines: Set<Polyline>.of(polylines.values),
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 200,
              width: 300,
              offset: 50,
            ),
          ],
        ),
      ),
    );
  }
}
