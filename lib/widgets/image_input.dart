import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _addImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
      // maxWidth: double.infinity,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _addImage,
      icon: const Icon(Icons.camera),
      label: const Text('Add Place'),
    );
    if (_selectedImage != null) {
      setState(() {
        content = GestureDetector(
          onTap: _addImage,
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        );
      });
    }
    return Container(
        alignment: Alignment.center,
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: content);
  }
}
