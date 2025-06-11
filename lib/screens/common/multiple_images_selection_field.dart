import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solar_cargo/screens/common/constants.dart';

import '../../generated/l10n.dart';

class MultiImageSelectionField extends StatefulWidget {
  final String label;
  final void Function(List<File>) onImagesSelected;
  final List<File>? initialImages;

  const MultiImageSelectionField({
    super.key,
    required this.label,
    required this.onImagesSelected,
    this.initialImages,
  });

  @override
  State<MultiImageSelectionField> createState() =>
      _MultiImageSelectionFieldState();
}

class _MultiImageSelectionFieldState extends State<MultiImageSelectionField> {
  final ImagePicker _picker = ImagePicker();
  late List<File> _selectedImages;

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.initialImages ?? [];
  }

  Future<void> _pickImages(ImageSource source) async {
    if (source == ImageSource.camera) {
      final pickedFile =
      await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } else {
      final pickedFiles = await _picker.pickMultiImage(imageQuality: 80);
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((pf) => File(pf.path)));
        });
      }
    }
    widget.onImagesSelected(_selectedImages);
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
                _pickImages(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(S.of(context).chooseFromGallery),
              onTap: () {
                Navigator.of(context).pop();
                _pickImages(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImageAt(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesSelected(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: Colors.white);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 5),
            child: Text(widget.label, style: labelStyle),
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
                      _selectedImages.isNotEmpty
                          ? '${_selectedImages.length} image(s) selected'
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
        if (_selectedImages.isNotEmpty)
          SingleChildScrollView(
            child: Column(
              children: List.generate(_selectedImages.length * 2 - 1, (i) {
                if (i.isOdd) {
                  return const SizedBox(height: 10);
                }
                final index = i ~/ 2;
                final file = _selectedImages[index];
                return Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: 220,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removeImageAt(index),
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
