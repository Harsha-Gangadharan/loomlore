import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> populateBoutiqueCollection() async {
  CollectionReference boutiques = FirebaseFirestore.instance.collection('boutiques');

  // Example boutique data
  List<Map<String, dynamic>> boutiqueData = [
    {
      'name': 'Boutique 1',
      'location': GeoPoint(37.7749, -122.4194),
    },
    {
      'name': 'Boutique 2',
      'location': GeoPoint(37.7849, -122.4094),
    },
    {
      'name': 'Boutique 3',
      'location': GeoPoint(37.7949, -122.4294),
    },
  ];

  // Add each boutique to Firestore
  for (var boutique in boutiqueData) {
    await boutiques.add(boutique);
  }

  print("Boutiques added to Firestore!");
}
