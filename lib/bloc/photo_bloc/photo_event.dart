part of 'photo_bloc.dart';

@immutable
sealed class PhotoEvent {}
class FetchPhotos extends PhotoEvent {
  final int page;
  final int photoPerPage;

  FetchPhotos({required this.page, required this.photoPerPage});
}

class RefreshPhotos extends PhotoEvent {
  final int photoPerPage;

  RefreshPhotos({required this.photoPerPage});
}

class ClearPhotos extends PhotoEvent {}  


