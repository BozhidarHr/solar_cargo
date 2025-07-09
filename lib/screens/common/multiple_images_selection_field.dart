import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solar_cargo/screens/common/constants.dart';

import '../../generated/l10n.dart';
import 'flash_helper.dart';

class MultiImageSelectionField extends StatefulWidget {
  final String label;
  final void Function(List<File>) onImagesSelected;
  final List<dynamic>? initialImages;

  const MultiImageSelectionField({
    super.key,
    required this.label,
    required this.onImagesSelected,
    this.initialImages,
  });

  @override
  State<MultiImageSelectionField> createState() => _MultiImageSelectionFieldState();
}

class _MultiImageSelectionFieldState extends State<MultiImageSelectionField> {
  final ImagePicker _picker = ImagePicker();
  late List<dynamic> _selectedImages;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.initialImages ?? [];
  }

  Future<void> _pickImages(ImageSource source) async {
    if (_selectedImages.length >= maxAdditionalImages) {
      FlashHelper.errorMessage(
        context,
        message: "You can select up to $maxAdditionalImages additional images.",
      );
      return;
    }

    if (source == ImageSource.camera) {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } else {
      final pickedFiles = await _picker.pickMultiImage(imageQuality: 70);
      if (pickedFiles.isNotEmpty) {
        final remaining = maxAdditionalImages - _selectedImages.length;
        final allowedFiles = pickedFiles.take(remaining).toList();

        if (pickedFiles.length > remaining) {
          String message = "You can select up to $maxAdditionalImages images.";
          if (remaining > 1) {
            message += "\nOnly the first $remaining will be added.";
          } else if (remaining == 1) {
            message += "\nOnly the first image will be added.";
          }
          FlashHelper.errorMessage(
            context,
            message: message,
            duration: const Duration(seconds: 2),
          );
        }

        setState(() {
          _selectedImages.addAll(allowedFiles.map((pf) => File(pf.path)).toList());
        });
      }
    }

    widget.onImagesSelected(_selectedImages.whereType<File>().toList());
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
    widget.onImagesSelected(_selectedImages.whereType<File>().toList());
  }

  Widget _buildImageWidget(dynamic file) {
    if (file is File) {
      return Image.file(file, width: 220, height: 150, fit: BoxFit.cover);
    } else if (file is String && file.startsWith('http')) {
      return Image.network(file, width: 220, height: 150, fit: BoxFit.cover);
    } else if (file is String) {
      return Image.file(File(file), width: 220, height: 150, fit: BoxFit.cover);
    }
    return const SizedBox.shrink();
  }

  Widget _buildImagePreview() {
    if (_selectedImages.isEmpty) return const SizedBox.shrink();

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
                "Images selected",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Row(
                children: [
                  const Text("View", style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 4),
                  Switch(
                    activeColor: Theme.of(context).primaryColor.withOpacity(0.5),
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
        const SizedBox(height: 10),
        if (_showPreview)
          Column(
            children: List.generate(_selectedImages.length, (index) {
              final file = _selectedImages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: _buildImageWidget(file),
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
                ),
              );
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle =
    Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 5),
            child: Text(widget.label, style: labelStyle),
          ),
        Visibility(
          visible: _selectedImages.length < maxAdditionalImages,
          child: GestureDetector(
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
        ),
        const SizedBox(height: 10),
        _buildImagePreview(),
      ],
    );
  }
}
