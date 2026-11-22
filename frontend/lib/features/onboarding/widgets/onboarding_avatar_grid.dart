import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_spacing.dart';

class OnboardingAvatarGrid extends StatelessWidget {
  final List<String> avatars;
  final String? selectedAvatar;
  final bool hasSelectedImageFile;
  final double avatarSize;
  final ValueChanged<String> onSelected;

  const OnboardingAvatarGrid({
    super.key,
    required this.avatars,
    required this.selectedAvatar,
    required this.hasSelectedImageFile,
    required this.avatarSize,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      alignment: WrapAlignment.center,
      children: avatars.map((avatarUrl) {
        final isSelected = selectedAvatar == avatarUrl && !hasSelectedImageFile;
        return GestureDetector(
          onTap: () => onSelected(avatarUrl),
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? theme.primaryColor : theme.dividerColor,
                width: isSelected ? 4 : 1,
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: ClipOval(
              child:
                  (avatarUrl.contains('.svg') ||
                      avatarUrl.contains('dicebear.com'))
                  ? SvgPicture.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      placeholderBuilder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    )
                  : Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: AppSpacing.xxl),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
