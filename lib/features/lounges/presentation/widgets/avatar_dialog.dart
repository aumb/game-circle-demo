import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/custom_dialog.dart';
import 'package:gamecircle/core/widgets/custom_divider.dart';
import 'package:gamecircle/core/widgets/profile_picture.dart';
import 'package:gamecircle/features/favorites/presentation/screens/favorite_lounges_screen.dart';
import 'package:gamecircle/features/logout/presentation/cubit/logout_cubit.dart';
import 'package:gamecircle/features/profile/presentation/screens/profile_screen.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AvatarDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      content: [
        Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfilePicture(),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sl<SessionManager>().user?.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    sl<SessionManager>().user?.email ?? '',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 16),
        CustomDivider(),
        _DialogListTile(
          label: Localization.of(context, 'profile'),
          icon: Icon(
            MdiIcons.homeEdit,
            size: 24,
          ),
          onTapped: () => _navigate(ProfileScreen(), context),
        ),
        CustomDivider(),
        _DialogListTile(
          label: Localization.of(context, 'favorites'),
          icon: Icon(
            MdiIcons.starCircle,
            color: CustomColors.secondaryAccent,
            size: 24,
          ),
          onTapped: () => _navigate(FavoriteLougnesScreen(), context),
        ),
        _DialogListTile(
          label: Localization.of(context, 'reviews'),
          icon: Icon(
            MdiIcons.commentOutline,
            color: CustomColors.secondaryAccent,
            size: 24,
          ),
        ),
        CustomDivider(),
        BlocProvider(
          create: (context) => sl<LogoutCubit>(),
          child: BlocConsumer<LogoutCubit, LogoutState>(
            listener: (context, state) {
              if (state is LogoutLoaded) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            builder: (context, state) {
              return _DialogListTile(
                isLoading: state is LogoutLoading,
                label: Localization.of(context, 'logout'),
                icon: Icon(
                  MdiIcons.logout,
                  size: 24,
                  color: CustomColors.errorColor,
                ),
                onTapped: () {
                  BlocProvider.of<LogoutCubit>(context).logout();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigate(Widget screen, BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
    Navigator.of(context).pop(result);
  }
}

class _DialogListTile extends StatelessWidget {
  final String label;
  final Icon? icon;
  final Function()? onTapped;
  final bool isLoading;

  const _DialogListTile({
    required this.label,
    this.onTapped,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Row(
                children: [
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator()),
                ],
              )
            : Row(
                children: [
                  icon ?? SizedBox.shrink(),
                  SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
