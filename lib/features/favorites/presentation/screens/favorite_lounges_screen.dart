import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/states/error_widget.dart';
import 'package:gamecircle/core/widgets/states/loading_widget.dart';
import 'package:gamecircle/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:gamecircle/features/lounges/presentation/widgets/lounge_card.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteLougnesScreen extends StatefulWidget {
  @override
  _FavoriteLougnesScreenState createState() => _FavoriteLougnesScreenState();
}

class _FavoriteLougnesScreenState extends State<FavoriteLougnesScreen> {
  late ScrollController _scrollController;
  late FavoritesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<FavoritesBloc>();
    _scrollController = ScrollController();
    _scrollController.addListener(listener);
    _bloc.add(GetFavoriteLoungesEvent());
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
      child: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesErrorMore) {
            final snackBar = SnackBar(
                content: Text(Localization.of(context, state.message ?? '')),
                behavior: SnackBarBehavior.floating);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                _buildAppBar(context),
                _buildAccordingToState(),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          Localization.of(context, 'favorites'),
          style: GoogleFonts.play(),
        ),
      ),
    );
  }

  Widget _buildAccordingToState() {
    if (_bloc.state is FavoritesLoading) {
      return _buildLoadingState();
    } else if (_bloc.state is FavoritesLoaded ||
        _bloc.state is FavoritesLoadedMore ||
        _bloc.state is FavoritesLoadingMore) {
      return _buildLoadedState();
    } else if (_bloc.state is FavoritesError) {
      final errorState = _bloc.state as FavoritesError;
      return _buildErrorState(errorState);
    } else {
      return SliverToBoxAdapter(child: Container());
    }
  }

  SliverToBoxAdapter _buildErrorState(FavoritesError errorState) {
    return SliverToBoxAdapter(
      child: CustomErrorWidget(
        isScreen: false,
        errorCode: errorState.code!,
        onPressed: () {
          _bloc.add(GetFavoriteLoungesEvent());
        },
      ),
    );
  }

  SliverList _buildLoadedState() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == _bloc.lounges.length - 1 &&
              _bloc.state is FavoritesLoadingMore) {
            return Column(
              children: [
                _buildLoungeCard(index),
                _buildLoadingMore(),
              ],
            );
          }
          return _buildLoungeCard(index);
        },
        childCount: _bloc.lounges.length,
      ),
    );
  }

  SliverToBoxAdapter _buildLoadingState() {
    return SliverToBoxAdapter(
      child: LoadingWidget(
        isScreen: false,
      ),
    );
  }

  Padding _buildLoungeCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LoungeCard(
        lounge: _bloc.lounges[index],
      ),
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
        _bloc.state is! FavoritesLoadingMore &&
        _bloc.canGetMoreLounges &&
        _bloc.state is! FavoritesError)
      _bloc.add(GetMoreFavoriteLoungesEvent());
  }
}
