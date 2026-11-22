import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/widgets/auth_widgets.dart';
import '../../../shared/widgets/backend_guard.dart';
import '../../../core/theme/app_spacing.dart';

class ProfileActionButtons extends StatelessWidget {
  final User? user;

  const ProfileActionButtons({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Row(
        children: [
          Expanded(
            child: BackendGuard(
              errorMessage: 'Cannot edit profile while offline',
              child: AuthButton(
                label: 'EDIT PROFILE',
                onPressed: () => context.push(RouteConstants.editProfile),
              ),
            ),
          ),
          if (user!.isAnonymous || user!.providerData.isEmpty) ...[
            AppSpacing.horizontalGapMD,
            Expanded(
              child: AuthButton(
                label: 'SIGN IN',
                onPressed: () =>
                    context.push('${RouteConstants.authLanding}?linking=true'),
              ),
            ),
          ],
        ],
      );
    } else {
      return AuthButton(
        label: 'SIGN IN',
        onPressed: () => context.push(RouteConstants.authLanding),
      );
    }
  }
}
