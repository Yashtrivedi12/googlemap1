import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(21.5397, 71.5776);
  CarouselController carouselController = CarouselController();
  List<LatLng> locations = [
    LatLng(21.5397, 71.5776), // Initial location
    LatLng(22.5397, 72.5776), // Example location 1
    LatLng(23.5397, 73.5776), // 
    LatLng(30.5397, 90.5776), // Initial location
    LatLng(50.5397, 105.5776), // Example location 1
    LatLng(70.5397, 120.5776), // Example location 2
    // Add more locations as needed
  ];
  int selectedLocationIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController!.animateCamera(
        CameraUpdate.newLatLng(locations[selectedLocationIndex]));
  }

  Set<Marker> _generateMarkers() {
    Set<Marker> markers = {};

    for (int i = 0; i < locations.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: locations[i],
          infoWindow: InfoWindow(
            title: 'Location $i',
            snippet:
                'Lat: ${locations[i].latitude}, Lng: ${locations[i].longitude}',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    return markers;
  }

  void _onCarouselPageChanged(int index) {
    setState(() {
      selectedLocationIndex = index;
      mapController!.animateCamera(
          CameraUpdate.newLatLng(locations[selectedLocationIndex]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _generateMarkers(),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(zoom: 11.0, target: _center),
          ),
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
            top: 500.0,
            child: CarouselSlider.builder(
              itemCount: locations.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Location $index Info\nLat: ${locations[index].latitude}, Lng: ${locations[index].longitude}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              carouselController: carouselController,
              options: CarouselOptions(
                enlargeCenterPage: true,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  _onCarouselPageChanged(index);
                },
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black, // Set the icon color
              ),
              onPressed: () {
                Navigator.pop(context);
                // Handle back button press here
              },
            ),
          ),
        ],
      ),
    );
  }
}
