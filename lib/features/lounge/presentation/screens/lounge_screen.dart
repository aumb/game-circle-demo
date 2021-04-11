import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/general_utils.dart';

import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/core/widgets/animations/shimmer.dart';
import 'package:gamecircle/core/widgets/custom_divider.dart';
import 'package:gamecircle/core/widgets/sliver_fab.dart';
import 'package:gamecircle/core/widgets/states/loading_widget.dart';
import 'package:gamecircle/features/lounge/presentation/bloc/lounge_bloc.dart';
import 'package:gamecircle/features/lounge/presentation/screens/games_search_screen.dart';
import 'package:gamecircle/features/lounge/presentation/widgets/lounge_game_card.dart';
import 'package:gamecircle/features/lounge/presentation/widgets/lounge_phone_and_rating.dart';
import 'package:gamecircle/features/lounge/presentation/widgets/lounge_pictures_carousel.dart';
import 'package:gamecircle/features/lounge/presentation/widgets/lounge_price_section_specs.dart';
import 'package:gamecircle/features/lounge/presentation/widgets/lounge_timings_widget.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:share/share.dart';

class LoungeScreen extends StatefulWidget {
  final Lounge lounge;

  const LoungeScreen({
    required this.lounge,
  });

  @override
  _LoungeScreenState createState() => _LoungeScreenState();
}

class _LoungeScreenState extends State<LoungeScreen> {
  late Size deviceSize;
  late LoungeBloc _bloc;
  bool shouldReload = false;

  @override
  void initState() {
    super.initState();
    _bloc = sl<LoungeBloc>(param1: widget.lounge);
    _bloc.add(GetLoungeEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (BuildContext context) => _bloc,
      child: BlocConsumer<LoungeBloc, LoungeState>(
        listener: (context, state) {
          if (state is FavoriteLoaded) {
            shouldReload = true;
          } else if (state is FavoriteError) {
            final snackBar = SnackBar(
                content: Text(Localization.of(context, state.message ?? '')),
                behavior: SnackBarBehavior.floating);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          List<Widget> loadedWidgets = [
            _buildOverview(),
            if (_bloc.fullLounge?.features != null &&
                _bloc.fullLounge!.features!.isNotEmpty)
              _buildFeaturesGrid(),
            if (_bloc.fullLounge?.sectionInformation != null &&
                _bloc.fullLounge!.sectionInformation!.isNotEmpty)
              _buildSections(),
            if (_bloc.fullLounge?.games != null &&
                _bloc.fullLounge!.games!.isNotEmpty)
              _buildGamesTitle(),
            if (_bloc.fullLounge?.games != null &&
                _bloc.fullLounge!.games!.isNotEmpty)
              _buildGamesGrid()
          ];
          List<Widget> loadingWidets = [
            SliverToBoxAdapter(
              child: LoadingWidget(
                isScreen: false,
              ),
            ),
          ];
          return Scaffold(
            body: SliverFab(
              expandedHeight: deviceSize.height * 0.3,
              floatingWidget: _buildFloatingActionButton(),
              slivers: [
                _buildSliverAppBar(),
                if (state is LoungeLoading) ...loadingWidets,
                if (state is LoungeLoaded ||
                    state is FavoriteError ||
                    state is FavoriteLoaded ||
                    state is FavoriteLoading)
                  ...loadedWidgets,
              ],
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturesGrid() {
    return SliverToBoxAdapter();
    // return SliverGrid.count(
    //   crossAxisCount: 2,
    //   childAspectRatio: 10,
    //   children: _bloc.fullLounge!.features!
    //       .map(
    //         (feature) => Padding(
    //           padding: const EdgeInsets.only(bottom: 8.0),
    //           child: Row(
    //             children: <Widget>[
    //               // Padding(
    //               //   padding: const EdgeInsets.only(right: 4.0),
    //               //   child: Icon(
    //               //     feature!.featured!
    //               //         ? Icons.check_circle
    //               //         : Icons.remove_circle,
    //               //     size: 20,
    //               //     color: feature.featured
    //               //         ? Theme.of(context).accentColor
    //               //         : Theme.of(context).errorColor,
    //               //   ),
    //               // ),
    //               Text(
    //                 feature?.name ?? '',
    //                 style: Theme.of(context).textTheme.caption,
    //               ),
    //             ],
    //           ),
    //         ),
    //       )
    //       .toList(),
    // );
  }

  SliverToBoxAdapter _buildOverview() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Localization.of(context, 'overview'),
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LoungeTimingsWidget(times: _bloc.timings),
                  LoungePhoneAndRating(lounge: _bloc.fullLounge!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSections() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16).copyWith(top: 0, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8),
            Text(
              Localization.of(context, 'sections'),
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LoungePriceSectionsSpecs(lounge: _bloc.fullLounge!),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildGamesTitle() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Localization.of(context, 'games'),
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildGamesGrid() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1 / 1,
          crossAxisCount: 2,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GameCard(
              index: index,
              imgUrl: _bloc.fullLounge?.games?[index]?.imgUrl ?? '',
              onTap: index == 3
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GamesSearchScreen(
                              games: _bloc.fullLounge!.games)));
                    }
                  : () {},
            );
          },
          childCount: _bloc.fullLounge!.games!.length <= 4
              ? _bloc.fullLounge!.games!.length
              : 4,
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      expandedHeight: deviceSize.height * 0.3,
      elevation: 4.0,
      pinned: true,
      leading: IconButton(
        icon: BackButtonIcon(),
        onPressed: () {
          Navigator.of(context).pop(shouldReload);
        },
      ),
      actions: <Widget>[
        _bloc.state is FavoriteLoading
            ? Row(
                children: <Widget>[
                  Container(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : IconButton(
                icon: Icon(
                  _bloc.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _bloc.isFavorite ? Theme.of(context).errorColor : null,
                ),
                onPressed: () {
                  _bloc.add(ToggleFavoriteStatusEvent());
                },
              ),
        IconButton(
          icon: Icon(
            Icons.share,
          ),
          onPressed: () {
            Share.share('check out my website https://example.com',
                subject: 'Look what I made!');
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          widget.lounge.name ?? '',
        ),
        background: _bloc.state is LoungeLoading
            ? Shimmer.fromColors(
                child: Container(
                  color: CustomColors.backgroundColor,
                ),
                baseColor: CustomColors.backgroundColor,
                highlightColor: CustomColors.accentColor)
            : LoungePicturesCarousel(
                images: _bloc.fullLounge?.images,
              ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(
        Icons.directions,
        size: 24,
      ),
      onPressed: () {
        GeneralUtils().launchCoordinates(37.4220041, -122.0862462);
      },
    );
  }
}
