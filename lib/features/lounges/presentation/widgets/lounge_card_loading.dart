import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';
import 'package:gamecircle/core/widgets/star_rating.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoungeCardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            _buildLogo(_width),
            SizedBox(width: 4),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    _buildNameAndNumberOfPlaces(context),
                    // SizedBox(height: 6),
                    // _buildRating(context),
                    // SizedBox(height: 6),
                    // _buildLocationInformation(context),
                    // SizedBox(height: 4),
                    // _buildDistance(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildDistance(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(MdiIcons.car),
        SizedBox(width: 4),
        Container(
          width: double.infinity,
          height: 12,
        ),
      ],
    );
  }

  Row _buildLocationInformation(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.place),
        SizedBox(width: 4),
        Expanded(
          child: Row(
            //Location
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildRating(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 12,
          color: Colors.white,
        ),
      ],
    );
  }

  Row _buildNameAndNumberOfPlaces(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 12,
          color: Colors.white,
          width: 15,
        ),
        // Row(
        //   children: <Widget>[
        //     Icon(
        //       Icons.desktop_windows,
        //       color: Theme.of(context).secondaryHeaderColor,
        //       size: 20,
        //     ),
        //     SizedBox(
        //       width: 4,
        //     ),
        //     Container(
        //       width: double.infinity,
        //       height: 12,
        //       color: Colors.white,
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Container _buildLogo(double _width) {
    return Container(
      width: _width * 0.2,
      height: _width * 0.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 0.5,
          color: CustomColors.white60,
        ),
      ),
    );
  }
}
