import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/widgets/image_source_sheet.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../../core/network/upload_service.dart';
import '../../../core/utils/toast_utils.dart';
import '../widgets/avatar_selector.dart';
import '../widgets/current_avatar_display.dart';
import '../../../shared/widgets/backend_guard.dart';
import '../../../core/theme/app_spacing.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;
  String? _nameError;

  // Track current avatar URL (selected from list or kept from profile)
  String? _selectedAvatarUrl;

  // Track a newly picked local file (only for non-anon users)
  File? _selectedImageFile;

  // Initial values to detect changes
  String _initialName = '';
  String? _initialPhotoUrl;

  bool _hasChanges = false;
  bool _isSaving = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.addListener(_onFieldChanged);

    // Initialize after first frame when we can read from ref
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authStateProvider).value;
      if (user != null) {
        setState(() {
          _initialName = user.displayName?.trim() ?? '';
          _initialPhotoUrl = user.photoURL;

          _selectedAvatarUrl = _initialPhotoUrl;
          _nameController.text = _initialName;
          _isInitializing = false;
          _hasChanges = false;
        });
      } else {
        setState(() => _isInitializing = false);
      }
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (_isInitializing) return;
    _validateName(_nameController.text);
    _updateHasChanges();
  }

  void _validateName(String val) {
    setState(() {
      if (val.isEmpty) {
        _nameError = 'Name is required';
      } else if (val.length < 3) {
        _nameError = 'Minimum 3 characters';
      } else if (val.length > 20) {
        _nameError = 'Maximum 20 characters';
      } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(val)) {
        _nameError = 'Letters, numbers, and underscores only';
      } else {
        _nameError = null;
      }
    });
  }

  void _updateHasChanges() {
    final nameChanged = _nameController.text.trim() != _initialName;
    final avatarUrlChanged = _selectedAvatarUrl != _initialPhotoUrl;
    final fileChanged = _selectedImageFile != null;
    setState(() {
      _hasChanges =
          (nameChanged || avatarUrlChanged || fileChanged) &&
          _nameError == null;
    });
  }

  bool get _isAnonymous {
    final user = ref.read(authStateProvider).value;
    return user == null || user.isAnonymous || user.providerData.isEmpty;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImageFile = File(image.path);
          _selectedAvatarUrl = null; // Clear URL selection in favour of file
        });
        _updateHasChanges();
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, 'Could not pick image: $e');
      }
    }
  }

  Future<void> _save() async {
    if (!_hasChanges || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      String? finalPhotoUrl;

      // If a local file was picked, upload it first
      if (_selectedImageFile != null) {
        final uploadService = ref.read(uploadServiceProvider);
        finalPhotoUrl = await uploadService.uploadAvatar(_selectedImageFile!);
      } else if (_selectedAvatarUrl != _initialPhotoUrl &&
          _selectedAvatarUrl != null) {
        finalPhotoUrl = _selectedAvatarUrl;
      }

      final String? newName = _nameController.text.trim() != _initialName
          ? _nameController.text.trim()
          : null;

      await ref
          .read(authRepositoryProvider.notifier)
          .updateProfile(name: newName, photoUrl: finalPhotoUrl);

      if (mounted) {
        ToastUtils.showSuccess(context, 'Profile updated successfully.');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // user is watched to ensure rebuild when auth state changes
    ref.watch(authStateProvider);
    final isAnon = _isAnonymous;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: _hasChanges
                ? BackendGuard(
                    errorMessage: 'Cannot save changes while offline',
                    child: TextButton(
                      key: const ValueKey('save_btn'),
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: AppSpacing.md,
                              height: AppSpacing.md,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Save',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('no_btn')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Name / Alias ───
            Text(
              'Name or Alias',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.verticalGapSM,
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Enter your name or alias',
                errorText: _nameError,
                filled: true,
                fillColor: theme.colorScheme.surface,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: theme.primaryColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: theme.primaryColor, width: 3),
                ),
              ),
            ),

            AppSpacing.verticalGapXXL,

            // ─── Avatar / Photo ───
            Text(
              'Avatar or Photo',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.verticalGapXXS,
            Text(
              isAnon
                  ? 'Select a character'
                  : 'Select a character or upload your own image',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
            AppSpacing.verticalGapSL,

            // Current avatar with edit pencil
            Center(
              child: Stack(
                children: [
                  CurrentAvatarDisplay(
                    imageFile: _selectedImageFile,
                    avatarUrl: _selectedAvatarUrl,
                    size: 100,
                  ),
                  if (!isAnon)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => ImageSourceSheet.show(
                          context,
                          title: 'Change Photo',
                          onSourceSelected: _pickImage,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(AppSpacing.xxs),
                          child: Icon(
                            Icons.edit,
                            color: theme.colorScheme.onPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            AppSpacing.verticalGapXL,

            // ─── Horizontal Avatar List ───
            AvatarSelector(
              selectedAvatarUrl: _selectedAvatarUrl,
              hasLocalFile: _selectedImageFile != null,
              onAvatarSelected: (url) {
                setState(() {
                  _selectedAvatarUrl = url;
                  _selectedImageFile = null;
                });
                _updateHasChanges();
              },
            ),
          ],
        ),
      ),
    );
  }
}
