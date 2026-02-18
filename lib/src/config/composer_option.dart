import 'package:flutter/widgets.dart';

/// Configuration for file upload in the composer
class FileUploadOption {
  const FileUploadOption({
    this.enabled = true,
    this.maxFileSize = 10 * 1024 * 1024,
    this.allowedMimeTypes = const [],
  });

  final bool enabled;
  final int maxFileSize;
  final List<String> allowedMimeTypes;
}

/// Configuration for the composer
class ComposerOption {
  const ComposerOption({
    this.placeholder,
    this.fileUpload = const FileUploadOption(),
    this.showToolPicker = false,
    this.showModelPicker = false,
    this.sendIcon,
    this.cancelIcon,
  });

  final String? placeholder;
  final FileUploadOption fileUpload;
  final bool showToolPicker;
  final bool showModelPicker;

  /// Custom icon data for the send button. Uses default arrow icon if null.
  final IconData? sendIcon;

  /// Custom icon data for the cancel/stop button. Uses default stop icon if null.
  final IconData? cancelIcon;
}
