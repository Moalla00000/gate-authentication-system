import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/string_utils.dart';
import '../../../core/theme/app_spacing.dart';

class ProfileHeader extends StatelessWidget {
  final User? user;

  const ProfileHeader({super.key, required this.user});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Placeholder data for unauthenticated users
    final displayName = (user?.displayName ?? 'Guest User').capitalize();
    final joinedDate = user?.metadata.creationTime != null
        ? 'Joined ${_formatDate(user!.metadata.creationTime)}'
        : 'Member since 2024';
    final photoURL = user?.photoURL;

    final bool isSvg =
        photoURL?.contains('.svg') == true ||
        photoURL?.contains('dicebear.com') == true;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              AppSpacing.verticalGapXS,
              Text(
                joinedDate,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              AppSpacing.verticalGapXXS,
              Text(
                '0 Friends',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.horizontalGapMD,
        CircleAvatar(
          radius: 46,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: ClipOval(
            child: photoURL == null
                ? Icon(
                    Icons.person,
                    size: 46,
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                : (isSvg
                      ? SvgPicture.network(
                          photoURL,
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                          placeholderBuilder: (context) =>
                              const CircularProgressIndicator(),
                        )
                      : Image.network(
                          photoURL,
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        )),
          ),
        ),
      ],
    );
  }
}
