import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/core/widgets/custom_text_field.dart';
import 'package:gamecircle/core/widgets/states/error_widget.dart';
import 'package:gamecircle/features/lounges/presentation/cubit/lounges_search_cubit.dart';
import 'package:gamecircle/features/lounges/presentation/widgets/lounge_card.dart';
import 'package:gamecircle/injection_container.dart';

class LoungesSearchScreen extends StatefulWidget {
  @override
  _LoungesSearchScreenState createState() => _LoungesSearchScreenState();
}

class _LoungesSearchScreenState extends State<LoungesSearchScreen> {
  late LoungesSearchCubit _cubit;
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cubit = sl<LoungesSearchCubit>();
    _scrollController = ScrollController();
    _scrollController.addListener(listener);
    _searchController = TextEditingController();
    _searchController.addListener(textListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<LoungesSearchCubit, LoungesSearchState>(
            listener: (context, state) {
              if (state is LoungesSearchErrorMore) {
                final snackBar = SnackBar(
                    content:
                        Text(Localization.of(context, state.message ?? '')),
                    behavior: SnackBarBehavior.floating);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
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
        isOutlineBorder: false,
        hintText: Localization.of(context, 'search'),
        onChanged: (v) {
          _searchController.text = v;
        },
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

  Widget _buildBodyAccordingToState(LoungesSearchState state) {
    if (state is LoungesSearchInitial) {
      return Expanded(child: _SearchSuggestion());
    } else if (state is LoungesSearchLoading) {
      return Expanded(child: _SearchLoading());
    } else if (state is LoungesSearchEmpty) {
      return Expanded(child: _SearchFailure());
    } else if (state is LoungesSearchLoaded ||
        state is LoungesSearchLoadingMore) {
      return Expanded(
        child:
            _SearchLoaded(scrollController: _scrollController, cubit: _cubit),
      );
    } else if (state is LoungesSearchError) {
      return Expanded(child: _SearchError(cubit: _cubit));
    } else {
      return Container();
    }
  }

  void listener() {
    double percentage =
        _scrollController.offset / _scrollController.position.maxScrollExtent;
    if (percentage > 0.8 &&
        _cubit.state is! LoungesSearchLoadingMore &&
        _cubit.canGetMoreLounges &&
        _cubit.state is! LoungesSearchError) _cubit.loadMore();
  }

  void textListener() {
    String currentValue = _searchController.text;
    _cubit.query = currentValue;
    _cubit.search();
  }
}

class _SearchError extends StatelessWidget {
  const _SearchError({
    Key? key,
    required LoungesSearchCubit cubit,
  })   : _cubit = cubit,
        super(key: key);

  final LoungesSearchCubit _cubit;

  @override
  Widget build(BuildContext context) {
    final state = _cubit.state as LoungesSearchError;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomErrorWidget(
          isScreen: false,
          errorCode: state.code!,
          onPressed: () {
            _cubit.search();
          },
        ),
      ],
    );
  }
}

class _SearchLoaded extends StatelessWidget {
  const _SearchLoaded({
    Key? key,
    required ScrollController scrollController,
    required LoungesSearchCubit cubit,
  })   : _scrollController = scrollController,
        _cubit = cubit,
        super(key: key);

  final ScrollController _scrollController;
  final LoungesSearchCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            // controller: _scrollController,
            itemBuilder: (ctx, index) {
              if (index == _cubit.lounges.length - 1 &&
                  _cubit.state is LoungesSearchLoadingMore) {
                return Column(
                  children: [
                    LoungeCard(
                      lounge: _cubit.lounges[index],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                );
              }
              return LoungeCard(
                lounge: _cubit.lounges[index],
              );
            },
            itemCount: _cubit.lounges.length,
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
