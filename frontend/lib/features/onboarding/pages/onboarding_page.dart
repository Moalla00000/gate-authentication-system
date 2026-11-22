import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../auth/repositories/auth_repository.dart';
import '../../../core/network/upload_service.dart';
import '../../../core/utils/toast_utils.dart';
import '../widgets/language_step.dart';
import '../widgets/tutorial_step.dart';
import '../widgets/terms_step.dart';
import '../widgets/username_step.dart';
import '../widgets/avatar_step.dart';
import '../../../core/constants/app_constants.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 2: Terms
  // (Accepted implicitly by tapping the button on TermsStep)

  // Step 3: Username
  final _usernameController = TextEditingController();
  String? _usernameError;

  // Step 4: Avatar
  String? _selectedAvatar;
  File? _selectedImageFile;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < 4) {
      _pageController.animateToPage(
        _currentStep + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        return true; // Language (Already handled by onNext)
      case 1:
        return true; // Tutorial
      case 2:
        return true; // Terms
      case 3:
        return _usernameController.text.length >= 3 &&
            _usernameController.text.length <= 20 &&
            RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(_usernameController.text);
      case 4:
        return _selectedAvatar != null || _selectedImageFile != null;
      default:
        return false;
    }
  }

  int _getMaxAllowedPage() {
    for (int i = 0; i < 5; i++) {
      if (!_isStepValid(i)) return i;
    }
    return 4;
  }

  bool _canGoNext() => _isStepValid(_currentStep);

  Future<void> _finish() async {
    setState(() => _isSubmitting = true);
    try {
      final username = _usernameController.text.trim();

      String finalAvatarUrl = _selectedAvatar ?? '';

      // If they chose a custom photo, upload it first to get the URL
      if (_selectedImageFile != null) {
        final uploadService = ref.read(uploadServiceProvider);
        finalAvatarUrl = await uploadService.uploadAvatar(_selectedImageFile!);
      }

      await ref
          .read(authRepositoryProvider.notifier)
          .signInAnonymously(username, finalAvatarUrl);

      // Navigation is handled automatically by the router once
      // AuthState.authenticated is emitted after a successful backend sync.
      // markOnboardingCompleted() is also called by the repository — only
      // after the sync succeeds — to avoid race conditions.
    } catch (e) {
      // Backend sync failed: user stays on this step to retry.
      // The repository already deleted the ghost Firebase user.
      if (mounted) {
        ToastUtils.showError(
          context,
          'Account synchronization failed. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Onboarding Background & Navigation
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: _ConditionalForwardScrollPhysics(
                      getMaxAllowedPage: _getMaxAllowedPage,
                      parent: const BouncingScrollPhysics(),
                    ),
                    onPageChanged: (page) => setState(() => _currentStep = page),
                    children: [
                      LanguageStep(onNext: _nextPage),
                      TutorialStep(onNext: _nextPage),
                      TermsStep(
                        onNext: () {
                          _nextPage();
                        },
                      ),
                      UsernameStep(
                        controller: _usernameController,
                        errorText: _usernameError,
                        onNext: _canGoNext() ? _nextPage : null,
                        onChanged: (val) {
                          setState(() {
                            if (val.isEmpty) {
                              _usernameError = 'Username is required';
                            } else if (val.length < 3) {
                              _usernameError = 'Minimum 3 characters';
                            } else if (val.length > 20) {
                              _usernameError = 'Maximum 20 characters';
                            } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(val)) {
                              _usernameError =
                                  'Letters, numbers, and underscores only';
                            } else {
                              _usernameError = null;
                            }
                          });
                        },
                      ),
                      AvatarStep(
                        avatars: AssetConstants.avatars,
                        selectedAvatar: _selectedAvatar,
                        selectedImageFile: _selectedImageFile,
                        onNext: _isSubmitting ? null : _finish,
                        isLoading: _isSubmitting,
                        onSelected: (val) {
                          setState(() {
                            _selectedAvatar = val;
                            _selectedImageFile = null; // Clear picked file
                          });
                        },
                        onImageSelected: (file) {
                          setState(() {
                            _selectedImageFile = file;
                            _selectedAvatar = null; // Clear pre-set avatar
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Hidden Preloading Layer
            // We build the avatars off-screen to trigger the network fetch & caching
            // so they are ready when the user reaches the Avatar step.
            Offstage(
              child: Row(
                children: AssetConstants.avatars
                    .map((url) => SvgPicture.network(url, width: 1, height: 1))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom scroll physics that allows free backward swiping (right swipe)
/// but conditionally blocks forward swiping (left swipe) past the max allowed page.
class _ConditionalForwardScrollPhysics extends ScrollPhysics {
  final int Function() getMaxAllowedPage;

  const _ConditionalForwardScrollPhysics({
    required this.getMaxAllowedPage,
    super.parent,
  });

  @override
  _ConditionalForwardScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _ConditionalForwardScrollPhysics(
      getMaxAllowedPage: getMaxAllowedPage,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (position is ScrollPosition) {
      final maxPage = getMaxAllowedPage();
      final viewportDimension = position.viewportDimension;
      final maxScrollAllowed = maxPage * viewportDimension;

      // If the user tries to scroll past the maximum allowed page dimension
      // (considering 0-indexed pages where page 0 starts at 0.0 offset etc)
      if (value > maxScrollAllowed && value > position.pixels) {
        return value - position.pixels; // Prevent scrolling further right
      }
    }

    return super.applyBoundaryConditions(position, value);
  }
}
