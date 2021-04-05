import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool isScreen;

  const LoadingWidget({this.isScreen = false});

  @override
  Widget build(BuildContext context) {
    return isScreen ? _buildLoadingScreen() : _buildLoadingWidget();
  }

  Scaffold _buildLoadingScreen() {
    return Scaffold(
      body: _buildLoading(),
    );
  }

  Widget _buildLoadingWidget() {
    return _buildLoading();
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
