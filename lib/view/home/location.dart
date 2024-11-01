// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import

// class LocationPage extends StatefulWidget {
//   const LocationPage({super.key});

//   @override
//   State<LocationPage> createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   // late GoogleMapController _mapController;
//   Position? _currentPosition;
//   bool _isLoading = true;
//   String _error = '';
//   // Set<Marker> _boutiqueMarkers = {};

//   @override
//   void initState() {
//     super.initState();
//     // _checkConnectivityAndGetLocation();
//   }

//   // Method to check connectivity before fetching location
//   Future<void> _checkConnectivityAndGetLocation() async {
//     print("Checking connectivity...");
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         _error = 'No internet connection. Please try again later.';
//         _isLoading = false;
//       });
//       print("No internet connection.");
//       return;
//     }
//     await _handleLocationPermission();
//   }

//   // Method to handle location permissions
//   Future<void> _handleLocationPermission() async {
//     print("Checking location permissions...");
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _error = 'Location permission denied. Please enable location services.';
//           _isLoading = false;
//         });
//         print("Location permission denied.");
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _error = 'Location permissions are permanently denied. Please enable location services from the settings.';
//         _isLoading = false;
//       });
//       print("Location permissions denied forever.");
//       return;
//     }

//     await _getCurrentLocation();
//   }

//   // Method to get the current location
//   Future<void> _getCurrentLocation() async {
//     try {
//       print("Getting current location...");
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _isLoading = false;
//       });
//       print("Current location obtained: $_currentPosition");
//       _fetchBoutiqueData();  // Fetch boutique data after getting location
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to get location: ${e.toString()}';
//         _isLoading = false;
//       });
//       print("Error getting location: $e");
//     }
//   }


//   Future<void> _retryGetCurrentLocation() async {
//   try {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//       timeLimit: Duration(seconds: 10),
//     );
//     setState(() {
//       _currentPosition = position;
//     });
//   } catch (e) {
//     setState(() {
//       _error = 'Failed to get location after retrying: ${e.toString()}';
//     });
//   }
// }


//   // Method to fetch boutique data from Firestore
//   Future<void> _fetchBoutiqueData() async {
//     try {
//       print("Fetching boutique data from Firestore...");
//       CollectionReference boutiques = FirebaseFirestore.instance.collection('boutiques');
//       QuerySnapshot snapshot = await boutiques.get();
//       Set<Marker> markers = {};

//       for (var doc in snapshot.docs) {
//         var data = doc.data() as Map<String, dynamic>;
//         GeoPoint location = data['location'];
//         String name = data['name'];

//         markers.add(
//           Marker(
//             markerId: MarkerId(doc.id),
//             position: LatLng(location.latitude, location.longitude),
//             infoWindow: InfoWindow(title: name),
//           ),
//         );
//       }

//       setState(() {
//         // _boutiqueMarkers = markers;
//       });
//       // print("Boutique markers added: $_boutiqueMarkers");
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to load boutique data: ${e.toString()}';
//       });
//       print("Error fetching boutique data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {},
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.more_vert, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 child: ImageFiltered(
//                   imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                   child: Image.asset(
//                     'asset/h1.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 16,
//                 top: 50,
//                 child: Text(
//                   'Find Your Near Boutique',
//                   style: GoogleFonts.poppins(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : _error.isNotEmpty
//                     ? Center(
//                         child: Text(
//                           _error,
//                           style: TextStyle(color: Colors.red, fontSize: 16),
//                         ),
//                       )
//                     : _currentPosition != null
//                         ? GoogleMap(
//                             initialCameraPosition: CameraPosition(
//                               target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//                               zoom: 14.0,
//                             ),
//                             onMapCreated: (controller) {
//                               // _mapController = controller;
//                             },
//                             // markers: _boutiqueMarkers,  // Display boutique markers
//                             myLocationEnabled: true,
//                           )
//                         : Center(child: Text('Location not available')),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget { 
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String address = 'Fetching data';
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      double lat = position.latitude;
      double lon = position.longitude;
    } catch (e) {
      setState(() {
        address = 'Failed to get location: $e';
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> openMap({required GeoPoint location}) async {
    final latitude = location.latitude;
    final longitude = location.longitude;
    final googleMapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      throw 'Could not launch $googleMapUrl';
    }
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('boutiques').snapshots(), 
        builder: (context, snapshot) { 
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }

          final data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final boutique = data[index].data() as Map<String, dynamic>;
              final name = boutique['name'] ?? 'Unknown';
              final location = boutique['location'] as GeoPoint?;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(name),
                  trailing: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      if (location != null) {
                        openMap(location: location);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid location')),
                        );
                      }
                    },
                  ),
                  tileColor: Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
