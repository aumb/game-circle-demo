import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';
import 'package:gamecircle/core/widgets/star_rating.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoungeCard extends StatefulWidget {
  final Lounge? lounge;
  final Function()? onTap;

  const LoungeCard({
    this.lounge,
    this.onTap,
  });

  @override
  _LoungeCardState createState() => _LoungeCardState();
}

class _LoungeCardState extends State<LoungeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: InkWell(
          onTap: widget.onTap,
          child: Card(
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
                          SizedBox(height: 6),
                          _buildRating(context),
                          SizedBox(height: 6),
                          _buildLocationInformation(context),
                          SizedBox(height: 4),
                          if (widget.lounge?.distance != null)
                            _buildDistance(context),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
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
        Text((widget.lounge?.distance.toString() ?? '') + " km",
            style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  Row _buildLocationInformation(BuildContext context) {
    String? address = widget.lounge?.location?.address;
    String? city = widget.lounge?.location?.city;
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
            //Location
            children: <Widget>[
              Text(locationInformation ?? 'No known address',
                  style: Theme.of(context).textTheme.caption),
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
          rating: widget.lounge?.rating?.toDouble() ?? 0.0,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          widget.lounge?.rating?.toString() ?? '',
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          "(${widget.lounge?.reviewCount?.toString() ?? 0})",
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
            widget.lounge?.name ?? '',
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
                widget.lounge?.places?.toString() ?? '',
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
      imageUrl: widget.lounge?.logoUrl ?? '',
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
