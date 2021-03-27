import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/utils/images.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/custom_text_form_field.dart';
import 'package:gamecircle/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../injection_container.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ProfileCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cubit = sl<ProfileCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => _cubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            Navigator.of(context).pop(true);
          } else if (state is ProfileError) {
            final snackBar = SnackBar(
                content: Text(Localization.of(context, state.message ?? '')),
                behavior: SnackBarBehavior.floating);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              return Future.value((state is! ProfileLoading));
            },
            child: Scaffold(
              appBar: _buildAppBar(),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildProfilePicture(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          Localization.of(context, 'about'),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      _buildEmail(),
                      SizedBox(height: 16),
                      _buildName(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      actions: <Widget>[
        (_cubit.state is ProfileLoading)
            ? Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : InkWell(
                borderRadius: BorderRadius.circular(150),
                onTap: _cubit.canSubmitPage
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _cubit.submitProfile();
                        }
                      }
                    : null,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Localization.of(context, 'save'),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              )
      ],
    );
  }

  Material _buildProfilePicture() {
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () async {
          final pickedFile = await picker.getImage(source: ImageSource.gallery);

          if (pickedFile != null) {
            _cubit.setImage(File(pickedFile.path));
            print(_cubit.image?.lengthSync());
          } else {
            print('No image selected.');
          }
        },
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _cubit.image == null
                  ? CachedNetworkImage(
                      imageUrl: sl<SessionManager>().user?.imageUrl ?? '',
                      placeholder: (context, string) =>
                          Image.asset(Images.logoNoText),
                    )
                  : Image.file(_cubit.image!),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Icon(
                Icons.camera_alt,
                color: Theme.of(context).appBarTheme.iconTheme!.color,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomTextFormField(
        labelText: Localization.of(context, 'name'),
        hintText: Localization.of(context, 'name'),
        maxLength: 70,
        enabled: (_cubit.state is! ProfileLoading),
        initialValue: _cubit.name,
        onChanged: (String value) => _cubit.setName(value),
        validator: (v) {
          if (!_cubit.isNameValid) {
            return Localization.of(context, 'register_name_error');
          }
        },
      ),
    );
  }

  Container _buildEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomTextFormField(
        labelText: Localization.of(context, 'email'),
        hintText: Localization.of(context, 'email'),
        maxLength: 254,
        enabled: (_cubit.state is! ProfileLoading),
        initialValue: _cubit.email,
        onChanged: (String value) => _cubit.setEmail(value),
        validator: (v) {
          if (!_cubit.isEmailValid) {
            return Localization.of(context, 'register_email_error');
          }
        },
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _cubit.image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
