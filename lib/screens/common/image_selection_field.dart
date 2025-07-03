import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solar_cargo/screens/common/constants.dart';

import '../../generated/l10n.dart';

class ImageSelectionField extends StatefulWidget {
  final String label;
  final void Function(File?) onImageSelected;

  /// Can be a File (local) or a String (URL or file path)
  final dynamic initialImage;

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
  String? _initialImagePathOrUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.initialImage is File) {
      _selectedImage = widget.initialImage as File;
    } else if (widget.initialImage is String) {
      _initialImagePathOrUrl = widget.initialImage as String;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _initialImagePathOrUrl = null; // Clear the old image
      });
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
              title: Text(S.of(context).chooseFromGallery),
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

  Widget _buildImagePreview() {
    Widget imageWidget;

    if (_selectedImage != null) {
      imageWidget = Image.file(_selectedImage!, width: 220, height: 150, fit: BoxFit.cover);
    } else if (_initialImagePathOrUrl != null) {
      // Determine if it's a local file path or a URL
      if (_initialImagePathOrUrl!.startsWith('http')) {
        imageWidget = Image.network(_initialImagePathOrUrl!, width: 220, height: 150, fit: BoxFit.cover);
      } else {
        imageWidget = Image.file(File(_initialImagePathOrUrl!), width: 220, height: 150, fit: BoxFit.cover);
      }
    } else {
      return const SizedBox.shrink();
    }

    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageWidget,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedImage = null;
                _initialImagePathOrUrl = null;
                widget.onImageSelected(null);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _selectedImage != null || _initialImagePathOrUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, left: 5),
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
                      hasImage
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
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
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
        _buildImagePreview(),
      ],
    );
  }
}
