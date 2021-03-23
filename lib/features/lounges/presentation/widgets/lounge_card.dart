import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';
import 'package:gamecircle/core/widgets/star_rating.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoungeCard extends StatelessWidget {
  final Lounge? lounge;

  const LoungeCard({
    this.lounge,
  });

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (BuildContext context) =>
        //           GamingLoungeDetailsScreen(lounge: lounge)),
        // );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              _buildLogo(_width),
              SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: _width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildNameAndNumberOfPlaces(context),
                      _buildRating(context),
                      _buildLocationInformation(context),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _buildLocationInformation(BuildContext context) {
    String? address = lounge?.location?.address;
    String? city = lounge?.location?.city;
    String? locationInformation;
    if (address != null) {
      locationInformation = address;
    }
    if (city != null) {
      if (locationInformation == null) {
        locationInformation = city;
      } else {
        locationInformation = locationInformation + ", " + city;
      }
    }
    return Row(
      children: [
        Icon(Icons.place),
        SizedBox(width: 4),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            //Location
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(locationInformation ?? 'No known address',
                    style: Theme.of(context).textTheme.caption),
              ),
              SizedBox(width: 4),
              if (lounge?.distance != null)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(MdiIcons.car),
                      SizedBox(width: 2),
                      Text((lounge?.distance.toString() ?? '') + " km",
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
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
        StarRating(
          rating: lounge?.rating?.toDouble() ?? 0.0,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          lounge?.rating?.toString() ?? '',
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          "(${lounge?.reviewCount?.toString() ?? 0})",
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }

  Row _buildNameAndNumberOfPlaces(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            lounge?.name ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Tooltip(
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          message: "Available Pcs",
          child: Row(
            children: <Widget>[
              Icon(
                Icons.desktop_windows,
                color: Theme.of(context).secondaryHeaderColor,
                size: 20,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                lounge?.places?.toString() ?? '',
                style: Theme.of(context).textTheme.button!.copyWith(
                      color: Theme.of(context).textTheme.headline6!.color,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  CachedNetworkImage _buildLogo(double _width) {
    return CachedNetworkImage(
      imageUrl: lounge?.logoUrl ?? '',
      imageBuilder: (context, imageProvider) => Container(
        width: _width * 0.2,
        height: _width * 0.2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.5,
            color: CustomColors.white60,
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: _width * 0.2,
        height: _width * 0.2,
        decoration: BoxDecoration(
          color: CustomColors.backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.5,
            color: CustomColors.white60,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: _width * 0.2,
        height: _width * 0.2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.5,
            color: CustomColors.white60,
          ),
          image: DecorationImage(
            image: AssetImage(Images.logoNoText),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
