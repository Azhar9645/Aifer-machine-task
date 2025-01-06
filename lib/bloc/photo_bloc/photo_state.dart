part of 'photo_bloc.dart';

@immutable
sealed class PhotoState {}


class PhotoInitialState extends PhotoState {}

class PhotoLoadingState extends PhotoState {}

class PhotoSuccessState extends PhotoState {
  final List<String> photos;
  final int page;

  PhotoSuccessState(this.photos, this.page);
}

class PhotoEmptyState extends PhotoState {}

class PhotoErrorState extends PhotoState {
  final String message;
  PhotoErrorState(this.message);
}
