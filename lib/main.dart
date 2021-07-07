import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/managers/navgiation_manager.dart';
import 'package:gamecircle/core/utils/locale/locale_utils.dart';
import 'package:gamecircle/core/utils/theme.dart';
import 'package:gamecircle/core/widgets/states/error_widget.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/home/presentation/screens/home_screen.dart';
import 'package:gamecircle/features/locale/presentation/bloc/locale_bloc.dart';
import 'package:gamecircle/features/login/presentation/screens/login_screen.dart';
import 'package:gamecircle/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/dynamic_links/presentation/bloc/dynamic_links_bloc.dart';
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //blocs
  late AuthenticationBloc _bloc;
  late LocaleBloc _localesBloc;
  late DynamicLinksBloc _dynamicLinksBloc;
  late NotificationsBloc _notificationsBloc;

  @override
  void initState() {
    super.initState();
    _bloc = di.sl<AuthenticationBloc>();
    _localesBloc = di.sl<LocaleBloc>();
    _bloc.add(GetCachedTokenEvent());
    _localesBloc.add(GetCachedLocaleEvent());
    _dynamicLinksBloc = di.sl<DynamicLinksBloc>();
    _notificationsBloc = di.sl<NotificationsBloc>();
  }

  @override
  void dispose() {
    _bloc.close();
    _localesBloc.close();
    _dynamicLinksBloc.close();
    _notificationsBloc.close();
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
        BlocProvider<DynamicLinksBloc>(
          create: (BuildContext context) => _dynamicLinksBloc,
        ),
        BlocProvider<NotificationsBloc>(
          create: (BuildContext context) => _notificationsBloc,
        ),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp(
            title: 'GameCircle',
            navigatorKey: di.sl<NavigationManager>().navigatorKey,
            theme: AppTheme().themeData,
            locale: localeState.locale,
            supportedLocales: LocaleUtil.localeList,
            localizationsDelegates: LocaleUtil.localizationsDelegates,
            localeResolutionCallback: LocaleUtil.localeResolutionCallback,
            home: Scaffold(
              body: MultiBlocListener(
                listeners: [
                  BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {},
                  ),
                  BlocListener<LocaleBloc, LocaleState>(
                    listener: (context, state) {},
                  ),
                  BlocListener<DynamicLinksBloc, DynamicLinksState>(
                    listener: (context, state) {},
                  ),
                ],
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                  if (state is UnauthenticatedState) {
                    return LoginScreen();
                  } else if (state is AuthenticationError) {
                    return CustomErrorWidget(
                        errorCode: state.code!,
                        onPressed: () {
                          _localesBloc.add(GetCachedLocaleEvent());
                        });
                  } else
                    return HomeScreen();
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
