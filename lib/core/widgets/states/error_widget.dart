import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';
import 'package:gamecircle/core/widgets/buttons/custom_raised_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final int errorCode;
  final Function() onPressed;
  final bool isScreen;

  const CustomErrorWidget({
    required this.errorCode,
    required this.onPressed,
    this.isScreen = true,
  });

  bool get is500 => errorCode == 500;

  @override
  Widget build(BuildContext context) {
    return isScreen ? _buildErrorScreen(context) : _buildErrorWidget(context);
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      body: _buildWidget(context),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "An error has occured on our end 😔. Our support team has been notified, keep on smashing that retry button!",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          CustomRaisedButton(
            label: Localization.of(context, 'retry'),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
