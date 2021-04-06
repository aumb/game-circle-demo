import 'package:flutter/material.dart';
import 'package:gamecircle/core/widgets/animations/shimmer.dart';

class ShimmerList extends StatelessWidget {
  /// Number of skeleton items to show
  /// Default is 1
  final int items;

  /// A layout of how you want your skeleton to look like
  final Widget builder;

  /// Base Color of the skeleton list item
  /// Defaults to Colors.grey[300]
  final Color baseColor;

  /// Highlight Color of the skeleton list item
  /// Defaults to Colors.grey[100]
  // final Color highlightColor;

  /// Duration in which the transition takes place
  /// Defaults to Duration(seconds: 2)
  final Duration period;

  const ShimmerList({
    Key? key,
    this.items = 1,
    required this.builder,
    this.baseColor = const Color(0xFFE0E0E0),
    this.period = const Duration(seconds: 2),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: Theme.of(context).accentColor,
          direction: ShimmerDirection.ltr,
          period: period,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => Container(
              child: builder,
            ),
            itemCount: items,
          ),
        ),
      ],
    );
  }
}
