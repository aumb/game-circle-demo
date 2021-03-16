import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';
import 'package:gamecircle/core/widgets/buttons/custom_raised_button.dart';
import 'package:gamecircle/core/widgets/buttons/register_options_button.dart';
import 'package:gamecircle/core/widgets/custom_text_field.dart';
import 'package:gamecircle/core/widgets/toggle_visibility_icon.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_bloc.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:gamecircle/features/registration/presentation/screens/registration_screen.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _bloc;
  late LoginFormBloc _formBloc;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _bloc = sl<LoginBloc>();
    _formBloc = sl<LoginFormBloc>();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _bloc.close();
    _formBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<LoginBloc>(
                create: (BuildContext context) => _bloc,
              ),
              BlocProvider<LoginFormBloc>(
                create: (BuildContext context) => _formBloc,
              ),
            ],
            child: MultiBlocListener(
              listeners: [
                BlocListener<LoginBloc, LoginState>(
                  listener: (BuildContext context, state) {
                    if (state is Error) {
                      final snackBar = SnackBar(
                          content: Text(state.message ?? ''),
                          behavior: SnackBarBehavior.floating);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
                BlocListener<LoginFormBloc, LoginFormState>(
                  listener: (context, state) {},
                ),
              ],
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) =>
                    BlocBuilder<LoginFormBloc, LoginFormState>(
                        builder: (context, formState) {
                  return ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 24),
                            Container(
                              padding: EdgeInsets.all(24),
                              height: 276,
                              child: Image.asset(Images.logo),
                            ),
                            SizedBox(height: 24),
                            _buildEmailInput(state),
                            SizedBox(height: 24),
                            _buildPasswordInput(state, formState),
                            SizedBox(height: 24),
                            _buildSubmitButton(formState, state),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text("No account? Get started:"),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _buildRegisterOptionsButton(
                                        onPressed: () {
                                          _bloc.add(FacebookLoginEvent());
                                        },
                                        color: CustomColors.facebookColor,
                                        icon: MdiIcons.facebook,
                                      ),
                                      SizedBox(width: 16),
                                      _buildRegisterOptionsButton(
                                        onPressed: () {
                                          _bloc.add(GoogleLoginEvent());
                                        },
                                        icon: MdiIcons.google,
                                      ),
                                      SizedBox(width: 16),
                                      _buildRegisterOptionsButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  RegistrationScreen(),
                                            ),
                                          );
                                        },
                                        color: Theme.of(context).errorColor,
                                        icon: MdiIcons.email,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  RegisterOptionsButton _buildRegisterOptionsButton({
    required Function() onPressed,
    Color? color,
    required icon,
  }) {
    return RegisterOptionsButton(
      onPressed: onPressed,
      isCircular: true,
      size: 48,
      icon: icon,
      color: color,
    );
  }

  CustomRaisedButton _buildSubmitButton(
      LoginFormState formState, LoginState state) {
    return CustomRaisedButton(
      disabled: !formState.canSubmitForm,
      label: "Submit",
      isLoading: state is Loading,
      onPressed: () {
        _bloc.add(
          PostEmailLoginEvent(
            email: formState.email,
            password: formState.password,
          ),
        );
      },
    );
  }

  CustomTextField _buildPasswordInput(
      LoginState state, LoginFormState formState) {
    return CustomTextField(
      enabled: state is! Loading,
      labelText: "Password",
      hintText: "Password",
      focusNode: _passwordFocusNode,
      onSubmitted: _passwordSubmitted,
      obscureText: formState.obsecureText,
      suffixIcon: ToggleVisibilityIcon(
        condition: formState.obsecureText ?? false,
        onPressedOff: () {
          _formBloc.add(ChangedObsecureTextEvent(obsecureText: false));
        },
        onPressedOn: () {
          _formBloc.add(ChangedObsecureTextEvent(obsecureText: true));
        },
      ),
      onChanged: (String value) {
        _formBloc.add(ChangedPasswordEvent(password: value));
      },
    );
  }

  CustomTextField _buildEmailInput(LoginState state) {
    return CustomTextField(
      enabled: state is! Loading,
      labelText: "E-mail",
      hintText: "E-mail",
      focusNode: _emailFocusNode,
      onSubmitted: _emailSubmitted,
      maxLength: 254,
      onChanged: (String value) {
        _formBloc.add(ChangedEmailEvent(email: value));
      },
    );
  }

  void _emailSubmitted(String value) {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _passwordSubmitted(String value) {
    _dismissKeyboard();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
