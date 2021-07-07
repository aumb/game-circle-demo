import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/entities/gc_image.dart';
import 'package:gamecircle/core/managers/navgiation_manager.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/buttons/custom_raised_button.dart';
import 'package:gamecircle/core/widgets/custom_divider.dart';
import 'package:gamecircle/core/widgets/custom_text_form_field.dart';
import 'package:gamecircle/core/widgets/star_rating.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/presentation/blocs/add_edit_review_bloc/add_edit_review_bloc.dart';
import 'package:gamecircle/features/reviews/presentation/widgets/add_edit_review_image.dart';
import 'package:gamecircle/features/reviews/presentation/widgets/add_edit_review_image_preview.dart';
import 'package:gamecircle/features/reviews/presentation/widgets/add_edit_review_pop_up_menu.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddEditReviewScreen extends StatefulWidget {
  final Review? review;

  const AddEditReviewScreen({this.review});

  @override
  _AddEditReviewScreenState createState() => _AddEditReviewScreenState();
}

class _AddEditReviewScreenState extends State<AddEditReviewScreen> {
  late AddEditReviewBloc _bloc;
  late TextEditingController _reviewTextController;

  bool get isNewReview =>
      _bloc.review?.lounge != null && _bloc.review?.id == null;

  List<Widget> get allImageWidgets {
    List<Widget> imageWidgets = [];

    for (int i = 0; i < _bloc.allImages!.length; i++) {
      imageWidgets.add(AddEditReviewImage(
        gcImage: _bloc.allImages![i] is GCImage
            ? (_bloc.allImages![i] as GCImage)
            : null,
        fileImage:
            _bloc.allImages![i] is File ? (_bloc.allImages![i] as File) : null,
        onDeleteImage: () {
          _bloc.add(DeletedImageEvent(image: _bloc.allImages![i]));
        },
        onImageTap: () {
          sl<NavigationManager>().navigateTo(
            AddEditReviewImagePreview(
              images: _bloc.allImages,
              selectedImageIndex: i,
            ),
          );
        },
      ));
    }

    return imageWidgets;
  }

  @override
  void initState() {
    super.initState();
    _bloc = sl<AddEditReviewBloc>(param1: widget.review);
    _reviewTextController = TextEditingController();
    _reviewTextController.text = _bloc.review?.review ?? '';
  }

  @override
  void dispose() {
    _bloc.close();
    _reviewTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<AddEditReviewBloc, AddEditReviewState>(
        listener: (context, state) {
          if (state is AddEditReviewLoaded) {
            sl<NavigationManager>().goBack(true);
          } else if (state is AddEditReviewError) {
            final snackBar = SnackBar(
                content: Text(Localization.of(context, state.message ?? '')),
                behavior: SnackBarBehavior.floating);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildText(),

                              _buildReviewRating(),
                              //Divider.
                              SizedBox(height: 16),
                              CustomDivider(),
                              SizedBox(height: 16),
                              _buildReviewTextField(),

                              SizedBox(height: 16),
                              _buildImages(),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                _buildSubmitButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding _buildText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        Localization.of(context, 'rate_gaming_session'),
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Row _buildReviewRating() {
    return Row(
      children: <Widget>[
        StarRating(
          isLoading: _bloc.state is AddEditReviewDeleting ||
              _bloc.state is AddEditReviewLoading,
          rating: _bloc.reviewRating ?? 0.0,
          onRatingChanged: (rating) {
            if (_bloc.state is! AddEditReviewDeleting ||
                _bloc.state is! AddEditReviewLoading) {
              _bloc.add(ChangedRatingEvent(rating: rating));
            }
          },
          color: _bloc.ratingColor(),
          starSize: 32,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            _bloc.ratingText(),
            style: TextStyle(color: _bloc.ratingColor()),
          ),
        )
      ],
    );
  }

  CustomTextFormField _buildReviewTextField() {
    return CustomTextFormField(
      enabled: !(_bloc.state is AddEditReviewLoading ||
          _bloc.state is AddEditReviewDeleting),
      controller: _reviewTextController,
      onChanged: (reviewText) {
        _bloc.add(ChangedReviewEvent(reviewText: reviewText));
      },
      hintText: Localization.of(context, 'review_hint'),
      maxLines: 10,
      minLines: 1,
      isOutlineBorder: false,
    );
  }

  Container _buildSubmitButton() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16),
        child: CustomRaisedButton(
          label: Localization.of(context, 'submit').toUpperCase(),
          disabled:
              !_bloc.canSubmitPage || _bloc.state is AddEditReviewDeleting,
          isLoading: _bloc.state is AddEditReviewLoading,
          onPressed: () {
            if (!isNewReview) {
              _bloc.add(PatchReviewEvent());
            } else {
              _bloc.add(PostReviewEvent());
            }
          },
        ));
  }

  AppBar _buildAppBar() {
    final double _width = MediaQuery.of(context).size.width;
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, false),
      ),
      actions: [
        if (!isNewReview)
          _bloc.state is AddEditReviewDeleting
              ? Row(
                  children: [CircularProgressIndicator()],
                )
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: CustomColors.errorColor,
                  ),
                  onPressed: _bloc.state is AddEditReviewLoading
                      ? null
                      : () {
                          _bloc.add(DeleteReviewEvent());
                        },
                ),
      ],
      title: Text(
        Localization.of(context, !isNewReview ? 'edit_review' : 'add_review'),
        style: GoogleFonts.play(),
      ),
      bottom: PreferredSize(
        preferredSize: Size(_width, 10),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            _bloc.review?.lounge?.name ?? '',
            style: Theme.of(context).chipTheme.labelStyle,
          ),
        ),
      ),
    );
  }

  Column _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: <Widget>[
                ...allImageWidgets,
                if (allImageWidgets.length < 4)
                  AddEditReviewPopUpMenu(
                    onGalleryPick: _onGalleryPick,
                    onCameraPick: _onCameraPick,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onGalleryPick() async {
    FilePickerResult? images = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    final int remainingImages = 4 - _bloc.addedImages.length;

    if (images?.files != null && images!.files.isNotEmpty) {
      if (images.files.length <= remainingImages) {
        List<File> files = images.paths.map((path) {
          final File _file = File(path ?? '');
          return _file;
        }).toList();
        _bloc.add(AddedImageEvent(images: files));
      }
    }
  }

  void _onCameraPick() async {
    final PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (image != null) {
      final File fileImage = File(image.path);
      _bloc.add(AddedImageEvent(images: [fileImage]));
    }
  }
}
