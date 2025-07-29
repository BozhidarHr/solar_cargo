import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:solar_cargo/screens/common/constants.dart';

import '../../generated/l10n.dart';
import '../../services/solar_helper.dart';

class ImageSelectionField extends StatefulWidget {
  final String label;
  final void Function(File?) onImageSelected;
  final dynamic initialImage; // Can be File or String

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
  bool _showPreview = false;

  final _picker = ImagePickerAndroid()..useAndroidPhotoPicker = true;

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
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);

    if (source == ImageSource.camera) {
      final bytes = await imageFile.readAsBytes();
      final fixedBytes = await SolarHelper.fixExifRotation(bytes);

      await ImageGallerySaverPlus.saveImage(
        fixedBytes,
        quality: 100,
        name: "photo_${DateTime.now().millisecondsSinceEpoch}",
      );

      // Write fixed image bytes to a new temporary file
      final tempDir = imageFile.parent;
      final fixedFile = await File(
        '${tempDir.path}/fixed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ).writeAsBytes(fixedBytes);

      setState(() {
        _selectedImage = fixedFile;
        _initialImagePathOrUrl = null;
        _showPreview = false;
      });
      widget.onImageSelected(_selectedImage);
      return;
    }

    // For gallery or other sources, just use the picked image directly
    setState(() {
      _selectedImage = imageFile;
      _initialImagePathOrUrl = null;
      _showPreview = false;
    });
    widget.onImageSelected(_selectedImage);
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        bottom: true,
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

  Widget _buildImageWidget() {
    if (_selectedImage != null) {
      return Image.file(_selectedImage!,
          width: 220, height: 150, fit: BoxFit.cover);
    } else if (_initialImagePathOrUrl != null) {
      if (_initialImagePathOrUrl!.startsWith('http')) {
        return Image.network(_initialImagePathOrUrl!,
            width: 220, height: 150, fit: BoxFit.cover);
      } else {
        return Image.file(File(_initialImagePathOrUrl!),
            width: 220, height: 150, fit: BoxFit.cover);
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildImagePreview() {
    final hasImage = _selectedImage != null || _initialImagePathOrUrl != null;
    if (!hasImage) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.image, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                "Image selected",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Row(
                children: [
                  const Text(
                    "View",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    activeColor:
                        Theme.of(context).primaryColor.withOpacity(0.5),
                    value: _showPreview,
                    onChanged: (val) {
                      setState(() {
                        _showPreview = val;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        if (_showPreview)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: _buildImageWidget(),
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
                          child:
                              Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
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
            '${widget.label} Image',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        if (!hasImage)
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
                        S.of(context).noImageSelected,
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
