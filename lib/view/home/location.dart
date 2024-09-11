import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  String _error = '';
  Set<Marker> _boutiqueMarkers = {};

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndGetLocation();
  }

  // Method to check connectivity before fetching location
  Future<void> _checkConnectivityAndGetLocation() async {
    print("Checking connectivity...");
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _error = 'No internet connection. Please try again later.';
        _isLoading = false;
      });
      print("No internet connection.");
      return;
    }
    await _handleLocationPermission();
  }

  // Method to handle location permissions
  Future<void> _handleLocationPermission() async {
    print("Checking location permissions...");
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _error = 'Location permission denied. Please enable location services.';
          _isLoading = false;
        });
        print("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _error = 'Location permissions are permanently denied. Please enable location services from the settings.';
        _isLoading = false;
      });
      print("Location permissions denied forever.");
      return;
    }

    await _getCurrentLocation();
  }

  // Method to get the current location
  Future<void> _getCurrentLocation() async {
    try {
      print("Getting current location...");
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      print("Current location obtained: $_currentPosition");
      _fetchBoutiqueData();  // Fetch boutique data after getting location
    } catch (e) {
      setState(() {
        _error = 'Failed to get location: ${e.toString()}';
        _isLoading = false;
      });
      print("Error getting location: $e");
    }
  }

  // Method to fetch boutique data from Firestore
  Future<void> _fetchBoutiqueData() async {
    try {
      print("Fetching boutique data from Firestore...");
      CollectionReference boutiques = FirebaseFirestore.instance.collection('boutiques');
      QuerySnapshot snapshot = await boutiques.get();
      Set<Marker> markers = {};

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        GeoPoint location = data['location'];
        String name = data['name'];

        markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(title: name),
          ),
        );
      }

      setState(() {
        _boutiqueMarkers = markers;
      });
      print("Boutique markers added: $_boutiqueMarkers");
    } catch (e) {
      setState(() {
        _error = 'Failed to load boutique data: ${e.toString()}';
      });
      print("Error fetching boutique data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Image.asset(
                    'asset/h1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 50,
                child: Text(
                  'Find Your Near Boutique',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(
                        child: Text(
                          _error,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      )
                    : _currentPosition != null
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                              zoom: 14.0,
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            markers: _boutiqueMarkers,  // Display boutique markers
                            myLocationEnabled: true,
                          )
                        : Center(child: Text('Location not available')),
          ),
        ],
      ),
    );
  }
}
