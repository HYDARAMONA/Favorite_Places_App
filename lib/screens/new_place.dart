import 'dart:io';

import 'package:favorite_places/models/place_item.dart';
import 'package:favorite_places/providers/places_list_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});
  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreen();
}

class _NewPlaceScreen extends ConsumerState<NewPlaceScreen> {
  var itemName = '';
  final formKey = GlobalKey<FormState>();

  File? savedImage;
  PlaceLocation? chosenLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new Plcae',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (newValue) {
                  itemName = newValue!;
                },
                decoration: InputDecoration(
                  label: Text(
                    'Title',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              ImageInput(onPickImage: (image) => savedImage = image),
              const SizedBox(height: 10),
              LocationInput(
                  onPickedLocation: (location) => chosenLocation = location),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  formKey.currentState!.save();
                  ref.read(placesListProvider.notifier).addPlaceItem(
                        itemName,
                        savedImage!,
                        chosenLocation!,
                      );
                  Navigator.of(context).pop();
                },
                label: Text(
                  'Add Plcae',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                icon: const Icon(Icons.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
