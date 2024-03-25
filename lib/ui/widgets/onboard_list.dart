import 'package:flutter/material.dart';

import '../../app/app.package.export.dart';
import 'widget_export.dart';

class OnBoardList extends StatefulWidget {
  final List<String> onBoardBanners;
  final bool isReversed;
  const OnBoardList(
      {super.key, required this.onBoardBanners, required this.isReversed});

  @override
  State<OnBoardList> createState() => _OnBoardListState();
}

class _OnBoardListState extends State<OnBoardList> {
  final controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _scrollToTop();
      } else if (controller.position.pixels ==
          controller.position.minScrollExtent) {
        _scrollToBottom();
      }
    });
    super.initState();
  }

  void _initAnimation() {
    if (widget.isReversed) {
      controller.jumpTo(controller.position.maxScrollExtent);
    }
    widget.isReversed ? _scrollToTop() : _scrollToBottom();
  }

  void _scrollToTop() {
    controller.animateTo(controller.position.minScrollExtent,
        duration: Duration(seconds: widget.onBoardBanners.length * 2),
        curve: Curves.linear);
  }

  void _scrollToBottom() {
    controller.animateTo(controller.position.maxScrollExtent,
        duration: Duration(seconds: widget.onBoardBanners.length * 2),
        curve: Curves.linear);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) _initAnimation();
    });

    return Builder(builder: (context) {
      final banners = widget.onBoardBanners.isEmpty
          ? List.generate(5, (index) => "")
          : widget.onBoardBanners;
      const width = 120.00;
      const height = 240.00;
      return SizedBox(
        width: width,
        child: ListView.builder(
          controller: controller,
          itemCount: widget.onBoardBanners.length,
          itemBuilder: (context, index) {
            final url = banners[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: url.isEmpty
                    ? BuffySkeleton(
                        enabled: true,
                        effect: pulseEffect(context),
                        child: Container(height: height))
                    : CachedNetworkImage(
                        imageUrl: url, fit: BoxFit.fill, height: height),
              ),
            );
          },
        ),
      );
    });
  }
}
