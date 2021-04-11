import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/custom_dialog.dart';
import 'package:gamecircle/core/widgets/custom_divider.dart';
import 'package:gamecircle/features/lounges/data/models/timing_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/timing.dart';

class LoungeTimingsWidget extends StatelessWidget {
  final List<Timing?>? times;

  LoungeTimingsWidget({required this.times});

  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return _buildTimings(context);
  }

  GestureDetector _buildTimings(BuildContext context) {
    DateTime now = DateTime.now();
    List<Timing?>? timings = times ?? [];
    int currentDay = now.weekday;
    Timing? today = timings.firstWhere((timing) => timing?.day == currentDay,
        orElse: () => TimingModel(
            day: currentDay, open: false, closeTime: null, openTime: null));
    GestureDetector timingWidget;

    bool isOpen;
    bool isAllDay = false;

    //Checking if the place is open in general
    if (today?.open ?? false) {
      //Checking to see if all day
      if (today?.openTime != null && today?.closeTime != null) {
        isOpen = true;
        isAllDay = true;
      } else {
        //Checking to see if the place is open now
        if (now.isAfter(today?.openTime ?? now) ||
            now.isBefore(today?.closeTime ?? now)) {
          isOpen = false;
        } else {
          isOpen = true;
        }
      }
    } else {
      isOpen = false;
    }

    timingWidget = GestureDetector(
      onTap: () {
        _buildTimingsDialog(context, timings);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text(
              Localization.of(context, isOpen ? "open" : "closed"),
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: isOpen ? Colors.green : Theme.of(context).errorColor,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (isOpen)
                  Text(
                    isTwentyFourSeven(timings)
                        ? Localization.of(context, '24/7')
                        : isAllDay
                            ? Localization.of(context, 'all_day')
                            : "${today?.openTime} - ${today?.closeTime}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return timingWidget;
  }

  bool isTwentyFourSeven(List<Timing?>? timings) {
    bool isTwentyFourSeven = true;

    if (timings!.length != 7) {
      return false;
    } else {
      for (int i = 0; i < timings.length; i++) {
        if (isTwentyFourSeven) {
          if (timings[i]!.open! &&
              timings[i]?.openTime == null &&
              timings[i]?.closeTime == null) {
            isTwentyFourSeven = true;
          } else {
            isTwentyFourSeven = false;
          }
        } else {
          i = timings.length + 1;
        }
      }
    }
    return isTwentyFourSeven;
  }

  _buildTimingsDialog(BuildContext context, List<Timing?>? timings) {
    return showDialog(
        context: context,
        builder: (context) => CustomDialog(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              content: [
                Text(
                  Localization.of(context, 'opening_hours'),
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
                CustomDivider(),
                SizedBox(height: 8),
                ...timings!.map((e) {
                  String loungeDayName =
                      Days.values[e?.day?.toInt() ?? 7].value;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              Localization.of(context, loungeDayName),
                              textAlign: TextAlign.end,
                              style: e!.day == now.weekday - 1
                                  ? TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                            ),
                          ),
                          SizedBox(width: 16),
                          e.open!
                              ? Expanded(
                                  child: Text(
                                      e.openTime == null
                                          ? Localization.of(
                                              context, 'open_all_day')
                                          : "${e.openTime} - ${e.closeTime}",
                                      style: e.day == now.day
                                          ? TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )
                                          : null),
                                )
                              : Expanded(
                                  child: Text(
                                    Localization.of(context, 'closed'),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ],
            ));
  }
}
