import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tazkarti_system/shared/styles/icon_broken.dart';

class StadiumLocation extends StatefulWidget {

  final double latitude;
  final double longitude;

    const StadiumLocation({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);


  @override
  _MyAppState createState() => _MyAppState(latitude, longitude);
}

class _MyAppState extends State<StadiumLocation> {

  late double latitude;
  late double longitude;

  _MyAppState(this.latitude,this.longitude);

  late GoogleMapController mapController;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng stdLocation =  LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('104B2B'),
        leading: IconButton(
          icon: Icon(IconBroken.Arrow___Left_2, color: Colors.white,size: 28,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
            'Stadium Location',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 22,
              color: Colors.white,
            )
        ),
      ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: stdLocation,
            zoom: 17,
          ),
        ),
      );

  }

}