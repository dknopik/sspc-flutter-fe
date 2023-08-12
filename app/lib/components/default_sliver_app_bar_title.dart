import 'package:flutter/material.dart';

class DefaultSliverAppBarTitle extends StatefulWidget {
  final Widget? child;

  const DefaultSliverAppBarTitle({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  _DefaultSliverAppBarTitleState createState() =>
      _DefaultSliverAppBarTitleState();
}

class _DefaultSliverAppBarTitleState extends State<DefaultSliverAppBarTitle> {
  ScrollPosition? _position;
  bool? _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible! ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: widget.child,
    );
  }

  void _addListener() {
    _position = Scrollable.of(context).position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible = settings == null ||
        settings.currentExtent <=
            settings.minExtent + MediaQuery.of(context).size.height / 17;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }
}
