import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/core/widgets/custom_text_field.dart';
import 'package:gamecircle/features/lounge/presentation/cubit/games_search_cubit.dart';
import 'package:gamecircle/features/lounge/presentation/widgets/lounge_game_card.dart';
import 'package:gamecircle/features/lounges/domain/entities/game.dart';
import 'package:gamecircle/injection_container.dart';

class GamesSearchScreen extends StatefulWidget {
  final List<Game?>? games;

  const GamesSearchScreen({required this.games});

  @override
  _GamesSearchScreenState createState() => _GamesSearchScreenState();
}

class _GamesSearchScreenState extends State<GamesSearchScreen> {
  late GamesSearchCubit _cubit;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _cubit = sl<GamesSearchCubit>(param1: widget.games);
    _searchController = TextEditingController();
    _searchController.addListener(textListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<GamesSearchCubit, GamesSearchState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                children: [
                  _buildSearchBar(context),
                  _buildBodyAccordingToState(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Container _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: CustomColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: CustomColors.backgroundColor,
        child: Ink(
          child: Row(
            children: [
              _buildBackButton(context),
              _buildSearchTextField(context),
              _buildClearButton(),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Expanded _buildSearchTextField(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        controller: _searchController,
        isOutlineBorder: false,
        hintText: Localization.of(context, 'search'),
      ),
    );
  }

  AnimatedOpacity _buildClearButton() {
    return AnimatedOpacity(
      opacity: StringUtils().isEmpty(_cubit.query) ? 0 : 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOutCubic,
      child: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          _searchController.clear();
        },
      ),
    );
  }

  Widget _buildBodyAccordingToState(GamesSearchState state) {
    if (state is GamesSearchInitial) {
      return Expanded(child: _SearchSuggestion());
    } else if (state is GamesSearchLoading) {
      return Expanded(child: _SearchLoading());
    } else if (state is GamesSearchEmpty) {
      return Expanded(child: _SearchFailure());
    } else if (state is GamesSearchLoaded) {
      print(_cubit.allGames!.length);
      return Expanded(
        child: _SearchLoaded(cubit: _cubit),
      );
    } else {
      return Container();
    }
  }

  void textListener() {
    String currentValue = _searchController.text;
    _cubit.query = currentValue;
    _cubit.search();
  }
}

class _SearchLoaded extends StatelessWidget {
  const _SearchLoaded({
    Key? key,
    required GamesSearchCubit cubit,
  })   : _cubit = cubit,
        super(key: key);

  final GamesSearchCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1 / 1,
              crossAxisCount: 2,
            ),
            itemBuilder: (ctx, index) {
              return GameCard(
                imgUrl: _cubit.allGames?[index]?.imgUrl ?? '',
                onTap: () {},
              );
            },
            itemCount: _cubit.allGames?.length,
          ),
        ),
      ],
    );
  }
}

class _SearchLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
      ],
    );
  }
}

class _SearchFailure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.sentiment_dissatisfied, size: 100),
        Text(
          Localization.of(context, 'lounges_search_failure'),
          style: Theme.of(context).textTheme.subtitle2,
        )
      ],
    );
  }
}

class _SearchSuggestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.search, size: 100),
        Text(
          Localization.of(context, 'lounges_search_suggestion'),
          style: Theme.of(context).textTheme.subtitle2,
        )
      ],
    );
  }
}
