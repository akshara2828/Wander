import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:place_picker/place_picker.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:math';
LatLng? stop;
//bool set=false;
void main() {
  runApp(MyApp());
}
double roundDouble(double value, int places){
  num mod = pow(10.0, places);
  return (((value * mod).toInt()) / mod);
}
double roundDoubleNull(double? value, int places){
  num mod = pow(10.0, places);
  return (((value! * mod).toInt()) / mod);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage1(),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  Location _location = Location();
  bool set = false;
  get customLocation => null;

  void _onMapCreated(GoogleMapController _cntlr)
  {
    GoogleMapController _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      print(l.latitude);
      print(l.longitude);
      if (roundDouble(l.latitude!, 3) == roundDoubleNull(/*stop?.latitude*/37.42199,3)) {
        if (roundDouble(l.longitude!, 3) == roundDoubleNull(/*stop?.longitude*/-122.0846,3)) {
          if (!set) {
            // Create a timer for 42 seconds
            FlutterAlarmClock.createTimer(0);
            //print('set!');
            set = true;
          }
        }
      }
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your current location")
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
            Container(
              child: TextButton(
                child:Text("Select Your Stop"),
                onPressed: () {
                  showPlacePicker();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
          "AIzaSyAB-DkH8CJbh9t6NGdVK6qhy9W5MFEI_x4",displayLocation: customLocation,
        )));
    //print(result.latLng);
    stop=returnStop(result.latLng);
  }
  LatLng returnStop(LatLng? result){
    return result!;
  }

}

class MyHomePage1 extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(fontFamily: 'Gruppo', fontSize: 20, letterSpacing: 8.0,),
          title: Center(child: Text('Wander', style: TextStyle(fontFamily: 'Gruppo', fontSize: 18))),
        ),
        body:
          Center(child :Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Text('Hey', style: TextStyle(fontSize: 25, color: Colors.black, fontFamily: 'League_Spartan'),),
            const Text('Wanderer!', style: TextStyle(fontSize: 35, color: Colors.black, fontFamily: 'League_Spartan'),),



            const Text('Set Alarms not just anytime', style: TextStyle(fontSize: 14, color: Colors.white),),
            const Text('But also anywhere', style: TextStyle(fontFamily: 'Italianno', fontSize: 25, color: Colors.white),),
            const SizedBox(height: 20),
            ElevatedButton(
              style: style,
              onPressed:() {
                Navigator.of(ctxt).push(
                    MaterialPageRoute(builder: (context) => MyHomePage2()));
              },
              child: const Text('Get Started', style: TextStyle(fontSize: 15, color: Colors.black)),
            ),
          ],
        ),
        )
    );
  }
}
