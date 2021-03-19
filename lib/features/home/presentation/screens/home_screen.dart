import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/features/home/presentation/bloc/home_bloc.dart';
import 'package:gamecircle/features/logout/presentation/cubit/logout_cubit.dart';
import 'package:gamecircle/injection_container.dart';

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
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (BuildContext context) => _bloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {},
            ),
          ],
          child: BlocBuilder<HomeBloc, HomeState>(
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
              } else if (state is HomeLoaded) {
                return Center(
                  child: BlocProvider(
                    create: (context) => sl<LogoutCubit>(),
                    child: BlocConsumer<LogoutCubit, LogoutState>(
                      listener: (context, state) {
                        if (state is LogoutLoaded) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          child: state is LogoutLoading
                              ? CircularProgressIndicator()
                              : Text("test"),
                          onPressed: () {
                            BlocProvider.of<LogoutCubit>(context).logout();
                          },
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
