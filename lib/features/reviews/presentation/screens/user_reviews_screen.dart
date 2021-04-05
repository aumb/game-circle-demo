import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/features/reviews/presentation/blocs/user_reviews_bloc/user_reviews_bloc.dart';
import 'package:gamecircle/features/reviews/presentation/screens/add_edit_review_screen.dart';
import 'package:gamecircle/features/reviews/presentation/widgets/review_card.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';

class UserReviewsScreen extends StatefulWidget {
  @override
  _UserReviewsScreenState createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends State<UserReviewsScreen> {
  late ScrollController _scrollController;
  late UserReviewsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<UserReviewsBloc>();
    _scrollController = ScrollController();
    _scrollController.addListener(listener);
    _bloc.add(GetUserReviewsEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(listener);
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<UserReviewsBloc, UserReviewsState>(
        listener: (context, state) {
          if (state is UserReviewsErrorMore) {
            final snackBar = SnackBar(
                content: Text(Localization.of(context, state.message ?? '')),
                behavior: SnackBarBehavior.floating);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              top: false,
              bottom: true,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: true,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        Localization.of(context, 'reviews'),
                        style: GoogleFonts.play(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  _buildAccordingToState(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccordingToState() {
    if (_bloc.state is UserReviewsLoading) {
      return SliverToBoxAdapter(
        child: Column(
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );
    } else if (_bloc.state is UserReviewsLoaded ||
        _bloc.state is UserReviewsLoadedMore ||
        _bloc.state is UserReviewsLoadingMore) {
      return _buildReviewList();
    } else {
      return SliverToBoxAdapter(
        child: Container(),
      );
    }
  }

  SliverList _buildReviewList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == _bloc.reviews.length - 1 &&
              _bloc.state is UserReviewsLoadingMore) {
            return Column(
              children: [
                _buildLoungeReviewCard(index),
                _buildLoadingMore(),
              ],
            );
          }
          return _buildLoungeReviewCard(index);
        },
        childCount: _bloc.reviews.length,
      ),
    );
  }

  Padding _buildLoungeReviewCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ReviewCard(
          review: _bloc.reviews[index]!,
          onEdit: () async {
            final bool? result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AddEditReviewScreen(review: _bloc.reviews[index]!),
              ),
            );

            if (result ?? false) {
              _bloc.add(GetUserReviewsEvent());
            }
          }),
    );
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
        _bloc.state is! UserReviewsLoadingMore &&
        _bloc.canGetMoreReviews) _bloc.add(GetMoreUserReviewsEvent());
  }
}
