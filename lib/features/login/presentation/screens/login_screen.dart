import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';
import 'package:gamecircle/core/widgets/buttons/custom_raised_button.dart';
import 'package:gamecircle/core/widgets/buttons/register_options_button.dart';
import 'package:gamecircle/core/widgets/custom_text_field.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_bloc.dart';
import 'package:gamecircle/features/login/presentation/controllers/login_controller.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController _controller;
  late LoginBloc _bloc;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _bloc = sl<LoginBloc>();
    _controller = sl<LoginController>();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _bloc.drain();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: BlocProvider(
            create: (_) => _bloc,
            child: StreamBuilder<bool>(
                stream: _controller.canSubmitPageStream,
                builder: (context, snapshot) {
                  return BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
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
                                  height: 250,
                                  width: 250,
                                  child: Image.asset(Images.logo),
                                ),
                                SizedBox(height: 24),
                                CustomTextField(
                                  enabled: state is! Loading,
                                  labelText: "E-mail",
                                  hintText: "E-mail",
                                  focusNode: _emailFocusNode,
                                  onSubmitted: _emailSubmitted,
                                  maxLength: 254,
                                  onChanged: (String value) {
                                    _controller.email = value;
                                  },
                                ),
                                SizedBox(height: 24),
                                CustomTextField(
                                  enabled: state is! Loading,
                                  labelText: "Password",
                                  hintText: "Password",
                                  focusNode: _passwordFocusNode,
                                  onSubmitted: _passwordSubmitted,
                                  obscureText: _controller.obscurePassword,
                                  suffixIcon: (_controller.obscurePassword ??
                                          true)
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.visibility_off,
                                            color: Colors.white30,
                                          ),
                                          onPressed: () {
                                            _controller.obscurePassword = false;
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            Icons.visibility,
                                            color: Colors.white30,
                                          ),
                                          onPressed: () {
                                            _controller.obscurePassword = true;
                                          }),
                                  onChanged: (String value) {
                                    _controller.password = value;
                                  },
                                ),
                                SizedBox(height: 24),
                                CustomRaisedButton(
                                  disabled: !_controller.canSubmitPage,
                                  label: "Submit",
                                  isLoading: state is Loading,
                                  onPressed: () {
                                    _bloc.add(
                                      PostEmailLoginEvent(
                                        email: _controller.email,
                                        password: _controller.password,
                                      ),
                                    );
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text("No account? Get started:"),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          RegisterOptionsButton(
                                            onPressed: () {},
                                            isCircular: true,
                                            size: 48,
                                            icon: MdiIcons.facebook,
                                            color: CustomColors.facebookColor,
                                          ),
                                          SizedBox(width: 16),
                                          RegisterOptionsButton(
                                            onPressed: () {},
                                            isCircular: true,
                                            size: 48,
                                            icon: MdiIcons.google,
                                          ),
                                          SizedBox(width: 16),
                                          RegisterOptionsButton(
                                            onPressed: () {
                                              // Navigator.of(context).push(
                                              //   MaterialPageRoute(
                                              //     builder: (BuildContext context) =>
                                              //         RegisterWithEmailScreen(),
                                              //   ),
                                              // );
                                            },
                                            isCircular: true,
                                            size: 48,
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
                    },
                  );
                }),
          ),
        ),
      ),
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
