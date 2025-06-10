import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LicencePlateImageField extends StatefulWidget {
  final String label;
  final void Function(File?) onImageSelected;

  const LicencePlateImageField({
    super.key,
    required this.label,
    required this.onImageSelected,
  });

  @override
  State<LicencePlateImageField> createState() => _LicencePlateImageFieldState();
}

class _LicencePlateImageFieldState extends State<LicencePlateImageField> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
    await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.onImageSelected(_selectedImage);
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, left: 5, top: 15),
          child: Text(
            widget.label,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _selectedImage != null
                    ? Text(
                  _selectedImage!.path.split('/').last,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                )
                    : const Text(
                  'No image selected',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: _showImageSourceActionSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                ),
                child: const Text('Browse'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_selectedImage != null)
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.file(
                _selectedImage!,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImage = null;
                    widget.onImageSelected(_selectedImage);
                  });
                },
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
