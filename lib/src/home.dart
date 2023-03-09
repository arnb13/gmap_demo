import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final google_map_api_key = '';
  final locations = const [
    LatLng(23.7699653,90.402559),
    LatLng(23.7690205,90.3989846),
    LatLng(23.756960, 90.399024),
    LatLng(23.7557147,90.3933208),
  ];
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.7699653,90.402559),
    zoom: 14.4746,
  );

  Set<Marker> markers = {};
  Set<Polyline> polyline = {};
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarkerIcon () {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, 'assets/logo.PNG').then((value) {
        customIcon = value;
    });
  }

  @override
  void initState() {

    addMarker();

    //setCustomMarkerIcon();

    super.initState();
  }

  Future<void> addMarker() async {
    for (int i = 0; i < locations.length; i++) {

      final Uint8List? markerIcon = await getBytesFromAsset('assets/logo.PNG', 100);

      final icon = BitmapDescriptor.fromBytes(markerIcon!);

      markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: locations[i],
            icon: icon,
          ));
      if (i != locations.length - 1) {
        polyline.add(Polyline(
          polylineId: PolylineId(i.toString()),
          points: [locations[i], locations[i + 1]],
          color: Colors.lightGreen,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ));
      }
    }
    setState(() {

    });
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Demo'),
      ),
      body: getBody(),
    );
  }

  getBody() {

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      markers: markers,
      compassEnabled: true,
      polylines: polyline,
      mapToolbarEnabled: true,
      //mapToolbarEnabled: true,

    );
  }
}
