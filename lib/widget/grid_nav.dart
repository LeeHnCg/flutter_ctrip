import 'package:flutter/material.dart';
import 'package:flutter_ctrip/model/grid_nav_model.dart';

class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;
  final String name;

  const GridNav({Key key, @required this.gridNavModel, this.name = 'xiaomin'});

  @override
  Widget build(BuildContext context) {
    return Text(name);
  }
}
