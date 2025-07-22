import '../../../features/media/models/image_model.dart';

/// Mobile/Desktop stub implementation for MediaRepository
class WebMediaRepository {
  // Upload any Image using HTML File (for web) - stub for mobile
  Future<ImageModel> uploadImageFileInStorage({
    required dynamic file,
    required String path,
    required String imageName,
  }) async {
    throw UnsupportedError(
        'HTML File upload is not supported on this platform');
  }
}
