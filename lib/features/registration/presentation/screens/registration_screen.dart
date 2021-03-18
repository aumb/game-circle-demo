import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/buttons/custom_raised_button.dart';
import 'package:gamecircle/core/widgets/custom_text_form_field.dart';
import 'package:gamecircle/core/widgets/flat_app_bar.dart';
import 'package:gamecircle/core/widgets/page_title.dart';
import 'package:gamecircle/core/widgets/toggle_visibility_icon.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_form_bloc.dart';
import 'package:gamecircle/injection_container.dart';

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
      appBar: FlatAppBar(),
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Column(
                                children: [
                                  PageTitle(
                                      title: Localization.of(
                                          context, 'register_title')),
                                  SizedBox(height: 32),
                                  CustomTextFormField(
                                    enabled: state is! Loading,
                                    labelText: Localization.of(context, 'name'),
                                    hintText: Localization.of(context, 'name'),
                                    focusNode: _nameFocusNode,
                                    onSubmitted: _nameSubmitted,
                                    validator: (v) {
                                      if (!formState.isNameValid) {
                                        return Localization.of(
                                            context, 'register_name_error');
                                      }
                                    },
                                    maxLength: 70,
                                    onChanged: (v) {
                                      _formBloc.add(ChangedNameEvent(name: v));
                                    },
                                  ),
                                  SizedBox(height: 32),
                                  CustomTextFormField(
                                    enabled: state is! Loading,
                                    labelText:
                                        Localization.of(context, 'email'),
                                    hintText: Localization.of(context, 'email'),
                                    focusNode: _emailFocusNode,
                                    onSubmitted: _emailSubmitted,
                                    validator: (v) {
                                      if (!formState.isEmailValid) {
                                        return Localization.of(
                                            context, 'register_email_error');
                                      }
                                    },
                                    maxLength: 70,
                                    onChanged: (v) {
                                      _formBloc
                                          .add(ChangedEmailEvent(email: v));
                                    },
                                  ),
                                  SizedBox(height: 32),
                                  CustomTextFormField(
                                    enabled: state is! Loading,
                                    labelText:
                                        Localization.of(context, 'password'),
                                    hintText:
                                        Localization.of(context, 'password'),
                                    focusNode: _passwordFocusNode,
                                    onSubmitted: _passwordSubmitted,
                                    obscureText:
                                        formState.obsecureText ?? false,
                                    suffixIcon: ToggleVisibilityIcon(
                                      condition:
                                          formState.obsecureText ?? false,
                                      onPressedOff: () {
                                        _formBloc.add(ChangedObsecureTextEvent(
                                            obsecureText: false));
                                      },
                                      onPressedOn: () {
                                        _formBloc.add(ChangedObsecureTextEvent(
                                            obsecureText: true));
                                      },
                                    ),
                                    onChanged: (String value) {
                                      _formBloc.add(ChangedPasswordEvent(
                                          password: value));
                                    },
                                    validator: (v) {
                                      if (!formState.isPasswordValid) {
                                        return Localization.of(
                                            context, 'register_password_error');
                                      }
                                    },
                                  ),
                                  SizedBox(height: 32),
                                  CustomTextFormField(
                                    enabled: state is! Loading,
                                    labelText: Localization.of(
                                        context, 'confirm_password'),
                                    hintText: Localization.of(
                                        context, 'confirm_password'),
                                    focusNode: _confirmPasswordFocusNode,
                                    onSubmitted: _confirmPasswordSubmitted,
                                    obscureText:
                                        formState.obsecureText ?? false,
                                    suffixIcon: ToggleVisibilityIcon(
                                      condition:
                                          formState.obsecureText ?? false,
                                      onPressedOff: () {
                                        _formBloc.add(ChangedObsecureTextEvent(
                                            obsecureText: false));
                                      },
                                      onPressedOn: () {
                                        _formBloc.add(ChangedObsecureTextEvent(
                                            obsecureText: true));
                                      },
                                    ),
                                    onChanged: (String value) {
                                      _formBloc.add(ChangedConfirmPasswordEvent(
                                          confirmPassword: value));
                                    },
                                    validator: (v) {
                                      if (!formState.isConfirmPasswordValid) {
                                        return Localization.of(context,
                                            'register_confirm_password_error');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        child: CustomRaisedButton(
                          disabled: !formState.canSubmitForm,
                          isLoading: state is Loading,
                          label:
                              Localization.of(context, 'create').toUpperCase(),
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
                      ),
                    ],
                  );
                },
              );
            },
          ),
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
