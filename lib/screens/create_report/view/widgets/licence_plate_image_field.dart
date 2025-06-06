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
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (_selectedImage == null)
          ElevatedButton.icon(
            style:ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: const Size(160, 45),
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            onPressed: _showImageSourceActionSheet,
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Add Image'),
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
          )
        else
          const Text(
            'No image selected',
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }
}
