import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/features/home/presentation/bloc/home_bloc.dart';
import 'package:gamecircle/features/lounges/presentation/screens/lounges_screen.dart';

import '../../../../injection_container.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<HomeBloc>();
    _bloc.add(GetUserInformationEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => _bloc,
        ),
      ],
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () {
          _bloc.add(HomeRefreshEvent());
          return _bloc.firstWhere(
            (val) => val is HomeLoaded || val is LocationError,
          );
        },
        child: Scaffold(
          body: MultiBlocListener(
            listeners: [
              BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {},
              ),
            ],
            child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) {
                return (current is! HomeRefreshing);
              },
              builder: (context, state) {
                if (state is HomeLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HomeError) {
                  return Center(
                    child: ElevatedButton(
                      child: Text(state.message ?? ''),
                      onPressed: () {},
                    ),
                  );
                } else if (state is HomeLoaded || state is LocationError) {
                  return LoungesScreen();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
