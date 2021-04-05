import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/buttons/custom_raised_button.dart';
import 'package:gamecircle/core/widgets/custom_text_form_field.dart';
import 'package:gamecircle/core/widgets/toggle_visibility_icon.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_form_bloc.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegistrationBloc _bloc;
  late RegistrationFormBloc _formBloc;

  late FocusNode _nameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = sl<RegistrationBloc>();
    _formBloc = sl<RegistrationFormBloc>();
    setUpFocusNodes();
  }

  @override
  void dispose() {
    disposeFocusNodes();
    _bloc.close();
    _formBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<RegistrationBloc>(
            create: (BuildContext context) => _bloc,
          ),
          BlocProvider<RegistrationFormBloc>(
            create: (BuildContext context) => _formBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<RegistrationBloc, RegistrationState>(
              listener: (BuildContext context, state) {
                if (state is Error) {
                  final snackBar = SnackBar(
                      content: Text(state.message ?? ''),
                      behavior: SnackBarBehavior.floating);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (state is Loaded) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          ],
          child: BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) {
              return BlocBuilder<RegistrationFormBloc, RegistrationFormState>(
                builder: (context, formState) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              _buildAppBar(context),
                              _buildSpacer(),
                              _buildNameField(state, context, formState),
                              _buildSpacer(),
                              _buildEmailField(state, context, formState),
                              _buildSpacer(),
                              _buildPasswordField(state, context, formState),
                              _buildSpacer(),
                              _buildConfirmPasswordField(
                                  state, context, formState),
                            ],
                          ),
                        ),
                        _buildButton(formState, state, context)
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Padding _buildButton(RegistrationFormState formState, RegistrationState state,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: CustomRaisedButton(
        disabled: !formState.canSubmitForm,
        isLoading: state is Loading,
        label: Localization.of(context, 'create').toUpperCase(),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _bloc.add(PostEmailRegistrationEvent(
              email: formState.email,
              name: formState.name,
              password: formState.password,
              confirmPassword: formState.confirmPassword,
            ));
          }
        },
      ),
    );
  }

  SliverPadding _buildConfirmPasswordField(RegistrationState state,
      BuildContext context, RegistrationFormState formState) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      sliver: SliverToBoxAdapter(
        child: CustomTextFormField(
          enabled: state is! Loading,
          labelText: Localization.of(context, 'confirm_password'),
          hintText: Localization.of(context, 'confirm_password'),
          focusNode: _confirmPasswordFocusNode,
          onSubmitted: _confirmPasswordSubmitted,
          obscureText: formState.obsecureText ?? false,
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
            _formBloc.add(ChangedConfirmPasswordEvent(confirmPassword: value));
          },
          validator: (v) {
            if (!formState.isConfirmPasswordValid) {
              return Localization.of(
                  context, 'register_confirm_password_error');
            }
          },
        ),
      ),
    );
  }

  SliverPadding _buildPasswordField(RegistrationState state,
      BuildContext context, RegistrationFormState formState) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      sliver: SliverToBoxAdapter(
        child: CustomTextFormField(
          enabled: state is! Loading,
          labelText: Localization.of(context, 'password'),
          hintText: Localization.of(context, 'password'),
          focusNode: _passwordFocusNode,
          onSubmitted: _passwordSubmitted,
          obscureText: formState.obsecureText ?? false,
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
          validator: (v) {
            if (!formState.isPasswordValid) {
              return Localization.of(context, 'register_password_error');
            }
          },
        ),
      ),
    );
  }

  SliverPadding _buildEmailField(RegistrationState state, BuildContext context,
      RegistrationFormState formState) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      sliver: SliverToBoxAdapter(
        child: CustomTextFormField(
          enabled: state is! Loading,
          labelText: Localization.of(context, 'email'),
          hintText: Localization.of(context, 'email'),
          focusNode: _emailFocusNode,
          onSubmitted: _emailSubmitted,
          validator: (v) {
            if (!formState.isEmailValid) {
              return Localization.of(context, 'register_email_error');
            }
          },
          maxLength: 70,
          onChanged: (v) {
            _formBloc.add(ChangedEmailEvent(email: v));
          },
        ),
      ),
    );
  }

  SliverPadding _buildNameField(RegistrationState state, BuildContext context,
      RegistrationFormState formState) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      sliver: SliverToBoxAdapter(
        child: CustomTextFormField(
          enabled: state is! Loading,
          labelText: Localization.of(context, 'name'),
          hintText: Localization.of(context, 'name'),
          focusNode: _nameFocusNode,
          onSubmitted: _nameSubmitted,
          validator: (v) {
            if (!formState.isNameValid) {
              return Localization.of(context, 'register_name_error');
            }
          },
          maxLength: 70,
          onChanged: (v) {
            _formBloc.add(ChangedNameEvent(name: v));
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSpacer() => SliverToBoxAdapter(
        child: _RegistrationSpacer(),
      );

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          Localization.of(context, 'register_title'),
          style: GoogleFonts.play(),
        ),
      ),
    );
  }

  void _nameSubmitted(String value) {
    FocusScope.of(context).requestFocus(_emailFocusNode);
  }

  void _emailSubmitted(String value) {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _passwordSubmitted(String value) {
    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
  }

  void _confirmPasswordSubmitted(String value) {
    _dismissKeyboard();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void setUpFocusNodes() {
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  void disposeFocusNodes() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }
}

class _RegistrationSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 32);
  }
}
