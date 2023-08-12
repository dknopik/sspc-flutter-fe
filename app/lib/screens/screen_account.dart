import 'package:app/components/default_sliver_app_bar_title.dart';
import 'package:app/screens/screen_history_channels.dart';
import 'package:app/screens/screen_new_channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    late final TabController _tabController = TabController(
      length: 2,
      vsync: this,
    );

    final List<Widget> _tabScreens = const [
      NewChannel(
        key: ValueKey(1),
      ),
      HistoryChannels(
        key: ValueKey(2),
      ),
    ];

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0,
                  shadowColor: Colors.white,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: DefaultSliverAppBarTitle(
                    child: Text(
                      'Title',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  primary: true,
                  pinned: true,
                  expandedHeight: 200,
                  toolbarHeight: 50,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Opacity(
                              opacity:
                                  _getOpacity(context, constraints.maxHeight),
                              child: Container(
                                  child: Row(
                                children: [
                                  Text('User Title'),
                                  Column(
                                    children: [
                                      Text('Hello, xxx'),
                                      Text('your balance'),
                                      Text('1254 Units'),
                                      Text('1254 Units Consolidated'),
                                    ],
                                  )
                                ],
                              )),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size(double.infinity, 40),
                    child: Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Text('Current Channels'),
                            Text('History'),
                          ],
                        )),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: _tabScreens,
            ),
          ),
        ),
      ),
    );
  }

  double _getOpacity(BuildContext context, double currentExtend) {
    final FlexibleSpaceBarSettings settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
    double extendSpace = settings.maxExtent - settings.minExtent - 30;
    return ((currentExtend - settings.minExtent - 30) / extendSpace)
        .clamp(0, 1);
  }
}
