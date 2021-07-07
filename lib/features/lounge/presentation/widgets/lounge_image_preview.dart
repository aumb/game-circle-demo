import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/entities/gc_image.dart';
import 'package:gamecircle/core/managers/navgiation_manager.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/widgets/custom_dismissible.dart';
import 'package:gamecircle/core/widgets/flat_app_bar.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class LoungeImagePreview extends StatefulWidget {
  final int selectedImageIndex;
  final List<GCImage?>? images;

  const LoungeImagePreview({
    required this.images,
    required this.selectedImageIndex,
  });

  @override
  _LoungeImagePreviewState createState() => _LoungeImagePreviewState();
}

class _LoungeImagePreviewState extends State<LoungeImagePreview> {
  bool canDismiss = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlatAppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: CustomDismissible(
        disable: !canDismiss,
        key: Key("lounge_image_${widget.images?.first?.imageUrl}"),
        onDismissed: (_) => sl<NavigationManager>().goBack(),
        direction: DismissDirection.vertical,
        movementDuration: Duration(milliseconds: 0),
        resizeDuration: null,
        child: PhotoViewGallery.builder(
          scaleStateChangedCallback: (scale) {
            if (scale == PhotoViewScaleState.initial && !canDismiss) {
              canDismiss = true;

              if (mounted) setState(() {});
            } else if (scale != PhotoViewScaleState.initial && canDismiss) {
              canDismiss = false;
              if (mounted) setState(() {});
            }
          },
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(
                  widget.images?[index]?.imageUrl ?? ''),
              minScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(
                tag: widget.images![index]!.id!.toString() +
                    widget.images![index]!.imageUrl!,
              ),
            );
          },
          pageController: PageController(
            initialPage: widget.selectedImageIndex,
          ),
          itemCount: widget.images?.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          backgroundDecoration:
              BoxDecoration(color: CustomColors.backgroundColor),
        ),
      ),
    );
  }
}
