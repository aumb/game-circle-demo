import 'package:flutter/material.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/custom_divider.dart';
import 'package:gamecircle/core/widgets/profile_picture.dart';
import 'package:gamecircle/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:gamecircle/injection_container.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool shouldReloadLounges = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: () => Navigator.of(context).pop(shouldReloadLounges),
          ),
          expandedHeight: 100,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                bool shouldReload = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditProfileScreen(),
                  ),
                );

                if (shouldReload) {
                  shouldReloadLounges = true;
                  if (mounted) setState(() {});
                }
              },
            )
          ],
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              Localization.of(context, 'profile'),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                child: ProfilePicture(size: 130),
                tag: "profile_picture",
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              Localization.of(context, 'about'),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: CustomDivider(),
          ),
        ),
        SliverToBoxAdapter(
          child: _QuickActionProfile(
            icon: MdiIcons.account,
            label: sl<SessionManager>().user?.name ??
                Localization.of(context, 'no_name'),
          ),
        ),
        SliverToBoxAdapter(
          child: _QuickActionProfile(
            icon: MdiIcons.email,
            label: sl<SessionManager>().user?.email ??
                Localization.of(context, 'no_email'),
          ),
        ),
        // SliverToBoxAdapter(
        //   child: _QuickActionProfile(
        //     icon: MdiIcons.calendar,
        //     label:
        //         sl<SessionManager>().user?. ?? 'No date of birth provided.',
        //   ),
        // ),
      ]),
    );
  }
}

class _QuickActionProfile extends StatelessWidget {
  final Function()? onTap;
  final IconData? icon;
  final Color? iconColor;
  final String? label;

  const _QuickActionProfile({
    this.onTap,
    this.icon,
    this.iconColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).accentColor,
                  size: 24,
                ),
                SizedBox(width: 16),
                Text(
                  label ?? "",
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
