import 'dart:async';

import 'package:app/components/default_sliver_app_bar_title.dart';
import 'package:app/data/style.dart';
import 'package:app/screens/screen_dispute.dart';
import 'package:app/screens/screen_history_channels.dart';
import 'package:app/screens/screen_new_channel.dart';
import 'package:app/services/Channel.g.dart';
import 'package:app/services/database.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:app/services/link.dart';
import 'package:app/services/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

import '../services/formatting.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  final NFCNetwork network = NFCNetwork();

  final AppLinks appLinks = AppLinks();
  StreamSubscription<Uri>? linkSubscription;

  BigInt onChainBalance = BigInt.from(0);
  BigInt totalBalance = BigInt.from(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initLinks();
  }

  Future<void> initLinks() async {
    await MyWallet().initialization;
    final appLink = await appLinks.getInitialAppLink();
    if (appLink != null) {
      print('app link: $appLink');
      handleAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    linkSubscription = appLinks.uriLinkStream.listen((appLink) {
      print('late app link: $appLink');
      handleAppLink(appLink);
    });
  }

  void handleAppLink(Uri appLink) {
    final msg = fromLink(appLink);
    if (msg != null) {
      handleIncomingMessage(msg, context);
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // get onchain confirmed balance
    // get balance across all channels
    onChainBalance = await MyWallet().getOnChainBalance();
    totalBalance = await MyWallet().getTotalBalance();
    print('started listener');
    //network.startListener(context);

    await ChannelDB().getChannels(MyWallet()); // Read old channels from db
    super.setState(() {}); // to update widget data
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    late final TabController _tabController = TabController(
      length: 3,
      vsync: this,
    );

    final List<Widget> _tabScreens = [
      NewChannel(
        key: ValueKey(1),
        nfcNetwork: network,
      ),
      HistoryChannels(
        key: ValueKey(2),
      ),
      NewDispute(
        key: ValueKey(3),
      )
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.green
                                  ], // Your gradient colors
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'SSPC',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                              ),
                            ),
                            TextSpan(
                              text: ' Wallet',
                              style: TextStyle(
                                color: Color(0xFF565559),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                height: 1.1,
                              ),
                            )
                          ],
                        )),
                        SizedBox(
                          width: 35,
                        ),
                      ],
                    ),
                  ),
                  primary: true,
                  pinned: true,
                  expandedHeight: 180,
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
                                  margin: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFFF6F7FC),
                                  ),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 30.0,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue,
                                                Colors.green
                                              ], // Your gradient colors
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            MyWallet().Address(),
                                            style: Style.hidden,
                                            textScaleFactor: 0.75,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          // Text(
                                          //   'your balance',
                                          //   style: Style.hidden,
                                          // ),
                                          RichText(
                                              text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Balance: ${formatValue(totalBalance)}",
                                                style: Style.normal,
                                              )
                                            ],
                                          )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('${formatValue(onChainBalance)} confirmed',
                                            style: Style.hidden,
                                          ),
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
                          labelColor: Colors.black,
                          indicatorColor: Colors.black,
                          unselectedLabelColor: Color(0xFF565559),
                          dividerColor: Colors.black,
                          tabs: [
                            Text('Current Channels'),
                            Text('History'),
                            Text('Disputes'),
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
