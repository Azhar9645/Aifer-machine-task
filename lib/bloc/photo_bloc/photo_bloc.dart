import 'package:aifer/services/photo_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoService _photoService = PhotoService();
  List<String> _allPhotos = [];

  PhotoBloc() : super(PhotoInitialState()) {
    on<FetchPhotos>(_fetchPhotos);
    on<RefreshPhotos>(_refreshPhotos);
    on<ClearPhotos>(_clearPhotos); // Add event listener for ClearPhotos

  }

  void _fetchPhotos(FetchPhotos event, Emitter<PhotoState> emit) async {
    try {
      emit(PhotoLoadingState());
      final photos =
          await _photoService.fetchPhotos(event.page, event.photoPerPage);
      if (photos.isNotEmpty) {
                _allPhotos.addAll(photos);

        emit(PhotoSuccessState(List.from(_allPhotos), event.page));
      } else {
        emit(PhotoEmptyState());
      }
    } catch (e) {
      emit(PhotoErrorState('Failed to load photos.'));
    }
  }
  Future<void> _refreshPhotos(
      RefreshPhotos event, Emitter<PhotoState> emit) async {
    try {
      emit(PhotoLoadingState());
      _allPhotos.clear();  // Clear previous photos
      final photos =
          await _photoService.fetchPhotos(1, event.photoPerPage);

      if (photos.isNotEmpty) {
        _allPhotos.addAll(photos);
        emit(PhotoSuccessState(List.from(_allPhotos), 1));
      } else {
        emit(PhotoEmptyState());
      }
    } catch (e) {
      emit(PhotoErrorState('Failed to refresh photos.'));
    }
  }

  void _clearPhotos(ClearPhotos event, Emitter<PhotoState> emit) {
    _allPhotos.clear();  // Clears the list of photos
    emit(PhotoInitialState());  // Reset state to initial
  }
}