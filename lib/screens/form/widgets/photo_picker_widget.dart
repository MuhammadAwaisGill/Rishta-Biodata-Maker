import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../providers/biodata_provider.dart';
import '../../../services/image_service.dart';

class PhotoPickerWidget extends ConsumerWidget {
  const PhotoPickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoPath = ref.watch(biodataProvider).photoPath;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showPickerOptions(context, ref),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
                image: photoPath.isNotEmpty
                    ? DecorationImage(
                  image: FileImage(File(photoPath)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: photoPath.isEmpty
                  ? const Icon(
                Icons.add_a_photo_rounded,
                size: 36,
                color: AppColors.primary,
              )
                  : null,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            photoPath.isEmpty ? 'Add Photo' : 'Change Photo',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showPickerOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: AppColors.primary),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final file = await ImageService().pickFromCamera();
                if (file != null) {
                  ref
                      .read(biodataProvider.notifier)
                      .updatePhotoPath(file.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final file = await ImageService().pickFromGallery();
                if (file != null) {
                  ref
                      .read(biodataProvider.notifier)
                      .updatePhotoPath(file.path);
                }
              },
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}