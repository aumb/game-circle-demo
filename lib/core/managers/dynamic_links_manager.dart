import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/safe_print.dart';
import 'package:gamecircle/features/dynamic_links/presentation/bloc/dynamic_links_bloc.dart';
import 'package:gamecircle/features/lounge/presentation/screens/lounge_screen.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/injection_container.dart';

class DynamicLinksManager {
  Widget? navigateTo;

  Future<void> retrieveDynamicLink() async {
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        if (dynamicLink?.link.queryParameters.containsKey('id') ?? false) {
          String? id = dynamicLink?.link.queryParameters['id'];

          if (id != null) {
            _setDynamicNavigationScreen(id);
          }
        }
      });

      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          String? id = deepLink.queryParameters['id'];

          if (id != null) {
            _setDynamicNavigationScreen(id);
          }
        }
      }
    } catch (e) {
      safePrint(e.toString());
    }
  }

  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://gamecircle.page.link',
      link: Uri.parse('https://gamecircle.page.link.com/?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.exmaple.gamecircle',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.game-circle',
        minimumVersion: '1',
        // appStoreId: 'your_app_store_id',
      ),
    );
    var dynamicUrl = await parameters.buildShortLink();

    return dynamicUrl.shortUrl;
  }

  void _setDynamicNavigationScreen(String id) {
    int? intId = int.tryParse(id);
    navigateTo = LoungeScreen(
      isDynamicLink: true,
      lounge: Lounge(
        id: intId,
        places: null,
        rating: null,
        reviewCount: null,
        featured: null,
        name: null,
        logoUrl: null,
        contact: null,
        country: null,
        location: null,
        packages: null,
        timings: [],
        games: [],
        sectionInformation: null,
        features: [],
        distance: null,
        isFavorite: null,
        images: [],
      ),
    );

    sl<DynamicLinksBloc>().add(HandleDynamicLinkEvent());
  }
}
