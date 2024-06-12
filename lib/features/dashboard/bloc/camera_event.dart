sealed class CameraEvent {}

class InitializeCamera extends CameraEvent {}

class ToggleCamera extends CameraEvent {}

class TakePicture extends CameraEvent {}

class DisposeCamera extends CameraEvent {}

class UpdateZoomLevel extends CameraEvent {
  final double zoomLevel;

  UpdateZoomLevel(this.zoomLevel);
}
