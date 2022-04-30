import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../screens/stock/stock_balance_screen.dart';
import '../../screens/tabbar/home_screen.dart';
import '../../screens/tabbar/sales_history_screen.dart';
import '../../screens/tabbar/visitation_log_screen.dart';
import 'profile/profile_screen.dart';

import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/get_project_list_model.dart';

class DynamicTabbedPage extends StatefulWidget {
  const DynamicTabbedPage({Key? key}) : super(key: key);

  @override
  _DynamicTabbedPageState createState() => _DynamicTabbedPageState();
}

class _DynamicTabbedPageState extends State<DynamicTabbedPage> {
  final List<Widget> _children = [
    const HomeScreen(),
    StockbalanceScreen(true, Rows()),
    SalesHistoryScreen(true, Rows()),
    VisitationLogScreen(true, Rows()),
    const ProfileScreen(true),
  ];

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: ColorCodes.backgroundColor,
          body: _children[_currentIndex],
          floatingActionButton: FloatingActionButton(
            heroTag: Singleton.instance.getRandString(7),
            backgroundColor: ColorCodes.tabSelectedColor,
            //Floating action button on Scaffold
            onPressed: () {
              //code to execute on button press

              onTabTapped(0);
            },
            child: const Icon(
              Icons.home,
              color: Colors.white,
              size: 35,
            ), //icon inside button
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          //floating action button position to center

          bottomNavigationBar: BottomAppBar(
            elevation: 8,
            //bottom navigation bar on scaffold
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            //shape of notch
            notchMargin: 5,
            //notche margin between floating button and bottom appbar
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                //children inside bottom appbar
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      onTabTapped(1);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "",
                          color: _currentIndex == 1
                              ? ColorCodes.tabSelectedColor
                              : ColorCodes.tabunSelectedColor,
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          Strings.stockScreen,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_12,
                              fontFamily: Constant.latoFontFamily,
                              textColor: _currentIndex == 1
                                  ? ColorCodes.tabSelectedColor
                                  : ColorCodes.tabunSelectedColor),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onTabTapped(2);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "",
                          color: _currentIndex == 2
                              ? ColorCodes.tabSelectedColor
                              : ColorCodes.tabunSelectedColor,
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          Strings.salesHistoryScreen,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_12,
                              fontFamily: Constant.latoFontFamily,
                              textColor: _currentIndex == 2
                                  ? ColorCodes.tabSelectedColor
                                  : ColorCodes.tabunSelectedColor),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: GestureDetector(
                      onTap: () {
                        onTabTapped(3);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "",
                            color: _currentIndex == 3
                                ? ColorCodes.tabSelectedColor
                                : ColorCodes.tabunSelectedColor,
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            Strings.visitationScreen,
                            style: Singleton.instance.setTextStyle(
                                fontSize: TextSize.text_12,
                                fontFamily: Constant.latoFontFamily,
                                textColor: _currentIndex == 3
                                    ? ColorCodes.tabSelectedColor
                                    : ColorCodes.tabunSelectedColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onTabTapped(4);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "",
                          color: _currentIndex == 4
                              ? ColorCodes.tabSelectedColor
                              : ColorCodes.tabunSelectedColor,
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          Strings.profileScreen,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_12,
                              fontFamily: Constant.latoFontFamily,
                              textColor: _currentIndex == 4
                                  ? ColorCodes.tabSelectedColor
                                  : ColorCodes.tabunSelectedColor),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
