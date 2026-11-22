import 'package:flutter/material.dart';
import 'package:gate_authentication_system/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/image_source_sheet.dart';
import 'onboarding_avatar_grid.dart';
import 'onboarding_bottom_frame.dart';

class AvatarStep extends StatefulWidget {
  final List<String> avatars;
  final String? selectedAvatar; // Will store the predefined URL
  final File?
  selectedImageFile; // Automatically set when user picks from gallery/camera
  final ValueChanged<String> onSelected;
  final ValueChanged<File> onImageSelected;
  final VoidCallback? onNext;
  final bool isLoading;

  const AvatarStep({
    super.key,
    required this.avatars,
    required this.selectedAvatar,
    this.selectedImageFile,
    required this.onSelected,
    required this.onImageSelected,
    this.onNext,
    this.isLoading = false,
  });

  @override
  State<AvatarStep> createState() => _AvatarStepState();
}

class _AvatarStepState extends State<AvatarStep> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageSelected(File(image.path));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.serverUnreachable),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Calculate avatar size for 3 columns
    final double avatarSize = (size.width - 48 - 32) / 3;

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xxxl,
              AppSpacing.lg,
              0,
            ),
            child: Column(
              children: [
                Text(
                  l10n.chooseAvatar,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.verticalGapXL,

                // Camera / Picked Image Button
                GestureDetector(
                  onTap: () => ImageSourceSheet.show(
                    context,
                    onSourceSelected: (source) => _pickImage(context, source),
                  ),
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.scaffoldBackgroundColor,
                      border: Border.all(
                        color: widget.selectedImageFile != null
                            ? theme.primaryColor
                            : theme.dividerColor,
                        width: widget.selectedImageFile != null ? 4 : 1,
                      ),
                    ),
                    padding: widget.selectedImageFile != null
                        ? const EdgeInsets.all(AppSpacing.xxs)
                        : EdgeInsets.zero,
                    child: widget.selectedImageFile != null
                        ? ClipOval(
                            child: Image.file(
                              widget.selectedImageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt,
                            color: theme.primaryColor,
                            size: avatarSize * 0.4,
                          ),
                  ),
                ),
                AppSpacing.verticalGapXL,

                // Pre-defined Avatars
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 180),
                    child: OnboardingAvatarGrid(
                      avatars: widget.avatars,
                      selectedAvatar: widget.selectedAvatar,
                      hasSelectedImageFile: widget.selectedImageFile != null,
                      avatarSize: avatarSize,
                      onSelected: widget.onSelected,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Continue Button
        OnboardingBottomFrame(
          show: widget.selectedAvatar != null || widget.selectedImageFile != null,
          isLoading: widget.isLoading,
          onNext: widget.onNext,
          label: l10n.finish,
        ),
      ],
    );
  }
}
