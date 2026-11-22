import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_spacing.dart';

class ImageSourceSheet extends StatelessWidget {
  final String title;
  final ValueChanged<ImageSource> onSourceSelected;

  const ImageSourceSheet({
    super.key,
    this.title = 'Select Photo',
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.verticalGapMD,
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                onSourceSelected(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                onSourceSelected(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    String title = 'Select Photo',
    required ValueChanged<ImageSource> onSourceSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.lg),
        ),
      ),
      builder: (context) =>
          ImageSourceSheet(title: title, onSourceSelected: onSourceSelected),
    );
  }
}
