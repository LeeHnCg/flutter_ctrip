import 'package:flutter/material.dart';
import 'package:flutter_ctrip/dao/home_dao.dart';
import 'package:flutter_ctrip/model/common_model.dart';
import 'package:flutter_ctrip/model/grid_nav_model.dart';
import 'package:flutter_ctrip/model/home_model.dart';
import 'package:flutter_ctrip/model/sales_box_model.dart';
import 'package:flutter_ctrip/util/navigator_util.dart';
import 'package:flutter_ctrip/widget/grid_nav.dart';
import 'package:flutter_ctrip/widget/loading_container.dart';
import 'package:flutter_ctrip/widget/local_nav.dart';
import 'package:flutter_ctrip/widget/sales_box.dart';
import 'package:flutter_ctrip/widget/search_bar.dart';
import 'package:flutter_ctrip/widget/sub_nav.dart';
import 'package:flutter_ctrip/widget/webview.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '我是你爸爸';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _appBarAlpha = 0;
  List<CommonModel> _bannerList = [];
  List<CommonModel> _localNavList = [];
  List<CommonModel> _subNavList = [];
  GridNavModel _gridNavModel;
  SalesBoxModel _salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    _handleRefresh();
    super.initState();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      _appBarAlpha = alpha;
    });
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        _bannerList = model.bannerList;
        _localNavList = model.localNavList;
        _gridNavModel = model.gridNav;
        _subNavList = model.subNavList;
        _salesBoxModel = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                },
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: _listView,
                ),
              ),
            ),
            _appBar
          ],
        ),
      ),
    );
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0x66000000), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80.0,
            decoration: BoxDecoration(color: Color.fromARGB((_appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              searchBarType: _appBarAlpha > 0.2 ? SearchBarType.homeLight : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: _appBarAlpha>0.2?0.5:0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 1)]
          ),
        )
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: _bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              CommonModel model = _bannerList[index];
              NavigatorUtil.push(
                  context, WebView(url: model.url, title: model.title, hideAppBar: model.hideAppBar));
            },
            child: Image.network(_bannerList[index].icon, fit: BoxFit.fill),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: _localNavList),
        ),
        Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4), child: GridNav(gridNavModel: _gridNavModel)),
        Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4), child: SubNav(subNavList: _subNavList)),
        Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4), child: SalesBox(salesBox: _salesBoxModel)),
      ],
    );
  }

  _jumpToSearch() {}

  _jumpToSpeak() {}
}
