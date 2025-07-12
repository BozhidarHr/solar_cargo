import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/services.dart';
import '../common/constants.dart';
import '../common/logger.dart';

class ProfilePicture extends StatefulWidget {
  final String? initialImageUrl;

  const ProfilePicture({
    super.key,
    required this.initialImageUrl,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final double _size = 60.0;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage() async {
    try {
      final source = await _selectImageSource();

      if (source == null) return;

      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
      });

      await _uploadProfilePicture(file);
    } catch (e) {
      printLog('Image pick error: $e');
    }
  }

  Future<void> _uploadProfilePicture(File image) async {
    try {
      await Services().api.changeProfilePicture(profilePicture: image);
    } catch (e) {
      printLog('Image upload error: $e');
    }
  }

  Widget _buildImageWidget() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, fit: BoxFit.cover);
    } else if (widget.initialImageUrl != null) {
      return Image.network(widget.initialImageUrl!, fit: BoxFit.cover);
    } else {
      return Image.asset(kWorkerImage, fit: BoxFit.cover);
    }
  }

  Future<ImageSource?> _selectImageSource() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      // _pickImage,
      child: CircleAvatar(
        radius: _size / 2,
        backgroundColor: Colors.grey.shade300,
        child: ClipOval(
          child: SizedBox(
            width: _size,
            height: _size,
            child: _buildImageWidget(),
          ),
        ),
      ),
    );
  }
}
