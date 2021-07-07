import 'package:flutter/material.dart';
import 'package:gamecircle/core/managers/navgiation_manager.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/reviews/presentation/screens/lounge_reviews_screen.dart';
import 'package:gamecircle/injection_container.dart';

class LoungePhoneAndRating extends StatelessWidget {
  final Lounge lounge;

  const LoungePhoneAndRating({required this.lounge});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (StringUtils().isNotEmpty(lounge.contact?.phoneNumber))
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // launch("tel://${lounge.phoneNumber}");
                    },
                    child: ClipOval(
                      child: Material(
                        elevation: 10.0,
                        color: Theme.of(context).cardColor,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.phone),
                        ),
                      ),
                    ),
                  ),
                ),
              InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  sl<NavigationManager>()
                      .navigateTo(LoungeReviewsScreen(lounge: lounge));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    color: Theme.of(context).accentColor,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            lounge.rating.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      lounge.reviewCount.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            fontSize: 10,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.87),
                                          ),
                                    ),
                                    Text(
                                      Localization.of(context, 'reviews')
                                          .toUpperCase(), //Reviews word
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(fontSize: 10),
                                    )
                                  ],
                                ),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
