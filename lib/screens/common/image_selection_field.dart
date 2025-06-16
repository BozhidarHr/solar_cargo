import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solar_cargo/screens/common/constants.dart';

import '../../generated/l10n.dart';

class ImageSelectionField extends StatefulWidget {
  final String label;
  final void Function(File?) onImageSelected;
  final File? initialImage;

  const ImageSelectionField({
    super.key,
    required this.label,
    required this.onImageSelected,
    this.initialImage,
  });

  @override
  State<ImageSelectionField> createState() => _ImageSelectionFieldState();
}

class _ImageSelectionFieldState extends State<ImageSelectionField> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
      widget.onImageSelected(_selectedImage);
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(S.of(context).takePhoto),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title:  Text(S.of(context).chooseFromGallery),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, left: 5, top: 0),
          child: Text(
            widget.label,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: _showImageSourceActionSheet,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: kFormFieldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      _selectedImage != null
                          ? "1 Image Selected"
                          : S.of(context).noImageSelected,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration:  BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5), // green background
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child:  Text(
                    S.of(context).browse,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_selectedImage != null)
          Center(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    width: 220,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
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
          ),
      ],
    );
  }
}
