import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/buttons/custom_outline_button.dart';
import 'package:gamecircle/core/widgets/profile_picture.dart';
import 'package:gamecircle/features/lounges/presentation/widgets/avatar_dialog.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounges_filter_option.dart';
import 'package:gamecircle/features/lounges/presentation/bloc/lounges_bloc.dart';
import 'package:gamecircle/features/lounges/presentation/screens/lounges_search_screen.dart';
import 'package:gamecircle/features/lounges/presentation/widgets/lounge_card.dart';
import 'package:gamecircle/injection_container.dart';

class LoungesScreen extends StatefulWidget {
  @override
  _LoungesScreenState createState() => _LoungesScreenState();
}

class _LoungesScreenState extends State<LoungesScreen> {
  late LoungesBloc _bloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant LoungesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.add(GetLoungesEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(listener);
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  _init() {
    _scrollController = ScrollController();
    _scrollController.addListener(listener);
    _bloc = sl<LoungesBloc>();
    _bloc.add(
      GetLoungesEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<LoungesBloc, LoungesState>(
        listener: (context, state) {
          if (state is LoungesErrorMore) {
            final snackBar = SnackBar(
                content: Text(Localization.of(context, state.message ?? '')),
                behavior: SnackBarBehavior.floating);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is! LoungesError) {
            return SafeArea(
              child: Scaffold(
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    _buildProfilePicture(),
                    _buildAppBar(deviceSize),
                    _buildFilterList(),
                    (state is LoungesLoading)
                        ? _buildLoungesLoading()
                        : _buildLoungesList(),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  SliverToBoxAdapter _buildProfilePicture() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ProfilePicture(onTap: () async {
              final bool? result = await showDialog(
                context: context,
                builder: (context) => AvatarDialog(),
              );

              if (result ?? false) {
                setState(() {});
              }
            }),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildLoungesLoading() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  SliverList _buildLoungesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == _bloc.lounges.length - 1 &&
              _bloc.state is LoungesLoadingMore) {
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

  SliverToBoxAdapter _buildFilterList() {
    List<LoungeFilterOption> filterOptions = LoungeFilterOption.values;
    final cards = <Widget>[];
    for (int i = 0; i < filterOptions.length; i++) {
      cards.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CustomOutlineButton(
            borderColor: _bloc.filter == filterOptions[i]
                ? Theme.of(context).accentColor
                : Theme.of(context).hintColor,
            textColor: _bloc.filter == filterOptions[i]
                ? Theme.of(context).accentColor
                : Theme.of(context).hintColor,
            label: filterOptions[i].value,
            onPressed: () {
              _bloc.setFilter(filterOptions[i]);
              _bloc.add(GetLoungesEvent());
            },
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: cards,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(Size deviceSize) {
    return SliverAppBar(
      floating: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => LoungesSearchScreen(),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.search, size: 26),
                    SizedBox(width: 4),
                    Text(
                      Localization.of(context, 'search'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.mic, size: 26),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void listener() {
    double percentage =
        _scrollController.offset / _scrollController.position.maxScrollExtent;
    if (percentage > 0.8 &&
        _bloc.state is! LoungesLoadingMore &&
        _bloc.canGetMoreLounges) _bloc.add(GetMoreLoungesEvent());
  }
}
