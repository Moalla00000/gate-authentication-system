import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displays the currently selected avatar, which could be a local file,
/// a network URL, or a fallback icon.
class CurrentAvatarDisplay extends StatelessWidget {
  final File? imageFile;
  final String? avatarUrl;
  final double size;

  const CurrentAvatarDisplay({
    super.key,
    required this.imageFile,
    required this.avatarUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget child;
    if (imageFile != null) {
      child = Image.file(imageFile!, fit: BoxFit.cover);
    } else if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      final isSvg =
          avatarUrl!.contains('.svg') || avatarUrl!.contains('dicebear.com');
      child = isSvg
          ? SvgPicture.network(avatarUrl!, fit: BoxFit.cover)
          : Image.network(avatarUrl!, fit: BoxFit.cover);
    } else {
      child = Icon(Icons.person, size: size * 0.5, color: theme.hintColor);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.dividerColor.withValues(alpha: 0.3),
        border: Border.all(color: theme.primaryColor, width: 3),
      ),
      child: ClipOval(child: child),
    );
  }
}
