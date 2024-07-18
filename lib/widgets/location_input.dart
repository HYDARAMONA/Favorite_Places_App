import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/models/place_item.dart';
import 'package:favorite_places/screens/map.dart';

class LocationInput extends StatefulWidget {
  LocationInput({super.key, required this.onPickedLocation});

  final void Function(PlaceLocation location) onPickedLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    //In the line below replace the "YOUR_API_KEY" with you google maps api key
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=YOUR_API_KEY';
  }

  _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }
    locationSaver(lat, lng);
  }

  //The function below will save the current or picked location data
  //and then pass the data to the form to generate a new place based on the data
  void locationSaver(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=YOUR_API_KEY');
    // in the avove line I should replace YOUR_API_KEY with the one from google maps api
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final adress = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: adress,
      );
      isGettingLocation = false;
    });

    widget.onPickedLocation(_pickedLocation!);
  }

  //the function below will retrieve the selected location data from the map screen
  void onMapSelect() async {
    final chosenLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );

    if (chosenLocation == null) {
      return;
    }

    locationSaver(chosenLocation.latitude, chosenLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No added location',
      // textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
    );

    if (_pickedLocation != null) {
      setState(() {
        previewContent = Image.network(
          locationImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      });
    }

    if (isGettingLocation) {
      setState(() {
        previewContent = CircularProgressIndicator();
      });
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('Get current location')),
            TextButton.icon(
                onPressed: onMapSelect,
                icon: const Icon(Icons.map),
                label: const Text('Select Location on map')),
          ],
        ),
      ],
    );
  }
}
