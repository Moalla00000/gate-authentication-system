import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_spacing.dart';

/// A horizontal scrollable list of pre-defined avatars.
class AvatarSelector extends StatelessWidget {
  final String? selectedAvatarUrl;
  final bool hasLocalFile;
  final ValueChanged<String> onAvatarSelected;

  const AvatarSelector({
    super.key,
    required this.selectedAvatarUrl,
    required this.hasLocalFile,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AssetConstants.avatars.length,
        separatorBuilder: (context, index) => AppSpacing.horizontalGapSM,
        itemBuilder: (context, index) {
          final url = AssetConstants.avatars[index];
          final isSelected = selectedAvatarUrl == url && !hasLocalFile;

          return GestureDetector(
            onTap: () => onAvatarSelected(url),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.primaryColor : theme.dividerColor,
                  width: isSelected ? 3.5 : 1.5,
                ),
              ),
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: SvgPicture.network(
                  url,
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
