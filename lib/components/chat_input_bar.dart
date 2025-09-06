import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../providers/language_provider.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String, {String? imagePath}) onSendMessage;
  final bool isLoading;

  const ChatInputBar({
    super.key,
    required this.onSendMessage,
    this.isLoading = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if ((message.isNotEmpty || _selectedImagePath != null) &&
        !widget.isLoading) {
      widget.onSendMessage(message, imagePath: _selectedImagePath);
      _messageController.clear();
      _selectedImagePath = null;
      setState(() {}); // Refresh UI to hide image preview
      _focusNode.requestFocus();
    }
  }

  Future<void> _pickImage() async {
    if (!mounted) return;

    try {
      // For Android 13+, we need to check for media permissions
      PermissionStatus status;

      // Check which permission to request based on Android version
      if (Platform.isAndroid) {
        // For Android 13+ use granular media permissions
        status = await Permission.photos.status;
        if (status.isDenied) {
          // Try the new media permission for Android 13+
          final mediaStatus = await Permission.manageExternalStorage.status;
          if (mediaStatus.isDenied) {
            status = await Permission.storage.status;
          }
        }
      } else {
        // For iOS
        status = await Permission.photos.status;
      }

      if (status.isGranted) {
        await _selectImage();
      } else if (status.isDenied) {
        // Request appropriate permission
        PermissionStatus requestResult;
        if (Platform.isAndroid) {
          requestResult = await Permission.storage.request();
        } else {
          requestResult = await Permission.photos.request();
        }

        if (requestResult.isGranted) {
          await _selectImage();
        } else if (requestResult.isPermanentlyDenied) {
          _showPermissionDialog();
        } else {
          _showPermissionSnackBar(
            "Photo permission is required to select images.",
          );
        }
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog();
      } else {
        // Try requesting permission anyway
        final requestResult = await Permission.storage.request();
        if (requestResult.isGranted) {
          await _selectImage();
        } else {
          _showPermissionDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        _showPermissionSnackBar("Error accessing photos: ${e.toString()}");
      }
    }
  }

  Future<void> _selectImage() async {
    try {
      // Try to pick image from gallery
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } on PlatformException catch (e) {
      String errorMessage = 'Error accessing gallery';

      // Handle specific platform exceptions
      if (e.code == 'photo_access_denied' || e.code == 'camera_access_denied') {
        errorMessage =
            'Permission denied. Please enable photo access in device settings.';
      } else if (e.code == 'invalid_image') {
        errorMessage = 'Invalid image selected. Please try another image.';
      } else {
        errorMessage = 'Cannot access gallery. Please check permissions.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to access gallery. Please restart the app or check device permissions.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _selectedImagePath = null;
    });
  }

  void _showPermissionDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
          'This app needs access to your photos to upload images. Please enable photo access in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text('Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showPermissionSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Settings',
          textColor: Colors.white,
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Image preview section
            if (_selectedImagePath != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedImagePath!),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Image selected',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      onPressed: _removeSelectedImage,
                    ),
                  ],
                ),
              ),
            // Input row
            Row(
              children: [
                // Image picker button
                GestureDetector(
                  onTap: widget.isLoading ? null : _pickImage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedImagePath != null
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.image,
                      color: _selectedImagePath != null
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      enabled: !widget.isLoading,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: widget.isLoading
                            ? languageProvider.getLoadingText()
                            : languageProvider.getInputHint(),
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: widget.isLoading ? null : _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.isLoading
                          ? Colors.grey.shade400
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: widget.isLoading
                        ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
