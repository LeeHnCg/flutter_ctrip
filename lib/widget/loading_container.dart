import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer({Key key, @required this.isLoading, this.cover = false, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!cover) {
      return !isLoading ? child : _loadingView;
    } else {
      return Stack(
        children: <Widget>[child, isLoading ? _loadingView : Container],
      );
    }
  }

  Widget get _loadingView {
    return Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
