import 'package:aifer/bloc/photo_bloc/photo_bloc.dart';
import 'package:aifer/utils/download_utils.dart';
import 'package:aifer/utils/request_permission.dart';
import 'package:aifer/widgets/photo_grid.dart';
import 'package:aifer/widgets/shimmer_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  final int _photosPerPage = 30;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    await requestStoragePermission(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_page == 1) {
      context
          .read<PhotoBloc>()
          .add(FetchPhotos(page: _page, photoPerPage: _photosPerPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper App'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoLoadingState && _page == 1) {
              return ShimmerGrid();
            } else if (state is PhotoErrorState) {
              return Center(child: Text(state.message));
            } else if (state is PhotoSuccessState) {
              return PhotoGrid(
                scrollController: _scrollController,
                photos: state.photos,
                onImageTap: _showImageDownloadDialog,
              );
            } else if (state is PhotoEmptyState) {
              return const Center(child: Text('No more photos.'));
            }
            return ShimmerGrid();
          },
        ),
      ),
    );
  }

  // Fetch more photos when the user scrolls to the bottom
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isFetching) {
      _isFetching = true;
      _page++;
      context
          .read<PhotoBloc>()
          .add(FetchPhotos(page: _page, photoPerPage: _photosPerPage));
    }
  }

  // Handle pull-to-refresh
  Future<void> _onRefresh() async {
    setState(() {
      _page = 1; 
    });

    context.read<PhotoBloc>().add(ClearPhotos());
    context.read<PhotoBloc>().add(RefreshPhotos(photoPerPage: _photosPerPage));

    await Future.delayed(const Duration(seconds: 1));
    _isFetching = false;
  }

  // Show dialog to download image
  void _showImageDownloadDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Download Image"),
          content:
              const Text("Do you want to download this image to your gallery?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _downloadImage(imageUrl);
              },
              child: const Text("Download"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadImage(String imageUrl) async {
    await DownloadUtils.downloadImage(imageUrl);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    FlutterDownloader.cancelAll(); // Cancel all ongoing downloads
    super.dispose();
  }
}
