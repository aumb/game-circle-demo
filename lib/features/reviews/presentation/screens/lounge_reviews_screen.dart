import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/managers/navgiation_manager.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/states/error_widget.dart';
import 'package:gamecircle/core/widgets/states/loading_widget.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/entities/reviews_filter_option.dart';
import 'package:gamecircle/features/reviews/presentation/blocs/lounge_reviews_bloc/lounge_reviews_bloc.dart';
import 'package:gamecircle/features/reviews/presentation/screens/add_edit_review_screen.dart';
import 'package:gamecircle/features/reviews/presentation/widgets/review_card.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';

class LoungeReviewsScreen extends StatefulWidget {
  final Lounge lounge;

  const LoungeReviewsScreen({required this.lounge});

  @override
  _LoungeReviewsScreenState createState() => _LoungeReviewsScreenState();
}

class _LoungeReviewsScreenState extends State<LoungeReviewsScreen> {
  late LoungeReviewsBloc _bloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = sl<LoungeReviewsBloc>(param1: widget.lounge);
    _scrollController = ScrollController();
    _scrollController.addListener(listener);
    _bloc.add(GetLoungeReviewsEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    _scrollController.removeListener(listener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<LoungeReviewsBloc, LoungeReviewsState>(
        listener: (context, state) {
          if (state is LoungeReviewsErrorMore) {
            final snackBar = SnackBar(
                content: Text(Localization.of(context, state.message ?? '')),
                behavior: SnackBarBehavior.floating);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: _buildFloatingActionButton(),
            appBar: _buildAppBar(),
            body: _buildAccordingToState(),
          );
        },
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await sl<NavigationManager>().navigateTo(
            AddEditReviewScreen(
              review: Review(
                lounge: widget.lounge,
              ),
            ),
          );

          if (result ?? false) {
            _bloc.add(GetLoungeReviewsEvent());
          }
        });
  }

  AppBar _buildAppBar() {
    return AppBar(
      bottom: _buildFilters(),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, false),
      ),
      centerTitle: true,
      title: Text(
        Localization.of(context, 'reviews'),
      ),
    );
  }

  PreferredSize _buildFilters() {
    List<Widget> filters = [];
    for (int i = 0; i < ReviewsFilterOption.values.length; i++) {
      filters.add(
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (_bloc.state is! LoungeReviewsLoading) {
                _bloc.setFilter(ReviewsFilterOption.values[i]);
                _bloc.add(GetLoungeReviewsEvent());
              }
            },
            child: Chip(
              label: Text(
                  Localization.of(
                      context, ReviewsFilterOption.values[i].valueText),
                  style: GoogleFonts.play().copyWith(
                    color: _bloc.filter == ReviewsFilterOption.values[i]
                        ? Theme.of(context).accentColor
                        : Theme.of(context).chipTheme.labelStyle.color,
                  )),
            ),
          ),
        ),
      );
    }
    return PreferredSize(
      preferredSize: Size(double.infinity, 30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Row(
          children: filters,
        ),
      ),
    );
  }

  Widget _buildAccordingToState() {
    if (_bloc.state is LoungeReviewsLoading) {
      return _buildLoadingState();
    } else if (_bloc.state is LoungeReviewsError) {
      return _buildErrorState();
    } else if (_bloc.state is LoungeReviewsLoaded ||
        _bloc.state is LoungeReviewsLoadedMore ||
        _bloc.state is LoungeReviewsLoadingMore ||
        _bloc.state is LoungeReviewsError) {
      return _buildLoadedState();
    } else {
      return Container();
    }
  }

  LoadingWidget _buildLoadingState() {
    return LoadingWidget();
  }

  CustomErrorWidget _buildErrorState() {
    final error = _bloc.state as LoungeReviewsError;
    return CustomErrorWidget(
        errorCode: error.code ?? 500,
        onPressed: () {
          _bloc.add(GetLoungeReviewsEvent());
        });
  }

  ListView _buildLoadedState() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      controller: _scrollController,
      itemBuilder: (ctx, index) {
        if (index == _bloc.reviews.length - 1 &&
            _bloc.state is LoungeReviewsLoadingMore) {
          return Column(
            children: [
              _buildLoungeReviewCard(index),
              _buildLoadingMore(),
            ],
          );
        }
        return _buildLoungeReviewCard(index);
      },
      itemCount: _bloc.reviews.length,
    );
  }

  _buildLoungeReviewCard(int index) {
    return ReviewCard(
        review: _bloc.reviews[index]!,
        onEdit: () async {
          final result = await sl<NavigationManager>().navigateTo(
            AddEditReviewScreen(
              review: _bloc.reviews[index]!,
            ),
          );

          if (result ?? false) {
            _bloc.add(GetLoungeReviewsEvent());
          }
        });
  }

  Padding _buildLoadingMore() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }

  void listener() {
    double percentage =
        _scrollController.offset / _scrollController.position.maxScrollExtent;
    if (percentage > 0.8 &&
        _bloc.state is! LoungeReviewsLoadingMore &&
        _bloc.canGetMoreReviews &&
        _bloc.state is! LoungeReviewsError)
      _bloc.add(GetMoreLoungeReviewsEvent());
  }
}
