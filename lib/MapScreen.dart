import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task/constants.dart';
import 'package:task/widget/customwidget.dart';
import 'package:toast/toast.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double distance = 0;
  Position position;
  LatLng destination;
  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  GoogleMapController _controller;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Polyline> _polyLines = Set<Polyline>();
  List<LatLng> polyLineCoords;
  PolylinePoints _polylinePoints;
  @override
  void initState() {
    _polylinePoints = PolylinePoints();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: GoogleMap(
              polylines: _polyLines,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController newcontroller) {
                _mapController.complete(newcontroller);
                _controller = newcontroller;
                checkPermission().catchError((error) {
                  Toast.show(error, context, duration: 4);
                });
              },
              onTap: onMapTapped,
            ),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: CustomWidget(distance: distance))
        ],
      ),
    );
  }

  Future<void> checkPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    // permissionCheck = await Geolocator.isLocationServiceEnabled();
    // if (!permissionCheck) {
    //   return Future.error("Location services are disabled.");
    // }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 20);
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void setPolyLines(LatLng source, LatLng dest) async {
    PolylineResult polylineResult =
        await _polylinePoints.getRouteBetweenCoordinates(
            mapkey,
            PointLatLng(source.latitude, source.longitude),
            PointLatLng(dest.latitude, dest.longitude));
    if (polylineResult.status == "OK") {
      polylineResult.points.forEach((points) {
        polyLineCoords.add(LatLng(points.latitude, points.longitude));
      });
      setState(() {
        _polyLines.add(Polyline(
            polylineId: PolylineId("polylineID"),
            width: 10,
            color: Colors.black,
            points: polyLineCoords));
      });
    }
  }

  void onMapTapped(newLatLng) {
    if (position == null) {
      return;
    }
    setState(() {
        distance = Geolocator.distanceBetween(position.latitude, position.longitude,
            newLatLng.latitude, newLatLng.longitude) /
        1000;
    destination = newLatLng;

    });
    LatLng source = LatLng(position.latitude, position.longitude);
    setPolyLines(source, destination);
  
  }
}
