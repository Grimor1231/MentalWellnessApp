import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Set<Marker> _markers = {};
  LatLng? _initialPosition;

  Future<void> fetchNearbyPlaces() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Position: $position');  // New print statement

      _initialPosition = LatLng(position.latitude, position.longitude);

      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=5000&type=hospital&key=AIzaSyA9LoSjyM7-PnBxacsZZkA9M0O0MeAkNGI'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final places = data['results'];
        Set<Marker> markers = Set();

        for (final place in places) {
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];

          markers.add(Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: place['name'],
              snippet: place['vicinity'],
            ),
          ));
        }

        setState(() {
          _markers = markers;
        });
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      print('Error: $e');  // New print statement
    }
  }


  @override
  void initState() {
    super.initState();
    fetchNearbyPlaces();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialPosition == null) {
      return CircularProgressIndicator();
    } else {
      return Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition!,
            zoom: 14.4746,
          ),
          markers: _markers,
        ),
      );
    }
  }
}
