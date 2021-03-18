import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/locale/locale_utils.dart';
import 'package:gamecircle/core/utils/theme.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/home/presentation/screens/home_screen.dart';
import 'package:gamecircle/features/locale/presentation/bloc/locale_bloc.dart';
import 'package:gamecircle/features/login/presentation/screens/login_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //blocs
  late AuthenticationBloc _bloc;
  late LocaleBloc _localesBloc;

  @override
  void initState() {
    super.initState();
    _bloc = di.sl<AuthenticationBloc>();
    _localesBloc = di.sl<LocaleBloc>();
    _bloc.add(GetCachedTokenEvent());
    _localesBloc.add(GetCachedLocaleEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    _localesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => _bloc,
        ),
        BlocProvider<LocaleBloc>(
          create: (BuildContext context) => _localesBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {},
          ),
          BlocListener<LocaleBloc, LocaleState>(
            listener: (context, state) {},
          ),
        ],
        child: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, localeState) {
            print(localeState.locale);
            return MaterialApp(
              title: 'GameCircle',
              theme: AppTheme().themeData,
              locale: localeState.locale,
              supportedLocales: LocaleUtil.localeList,
              localizationsDelegates: LocaleUtil.localizationsDelegates,
              localeResolutionCallback: LocaleUtil.localeResolutionCallback,
              home: Scaffold(
                body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is UnauthenticatedState) {
                      return LoginScreen();
                    } else {
                      return HomeScreen();
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
