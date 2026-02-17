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
  });

  final String? placeholder;
  final FileUploadOption fileUpload;
  final bool showToolPicker;
  final bool showModelPicker;
}
