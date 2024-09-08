import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/commons/widgets/promotion_layout/widget/promotion_list.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PromotionScreen extends HookConsumerWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 4);

    List<String> tabs = ["Tất cả", "Sale 1", "Sale 2", "Sale 3"];

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).unfocus();
      });
      return null;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AssetsConstants.primaryMain,
        elevation: 0,
        title: const Text(
          'Deals',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.orange,
              indicatorWeight: 2,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              tabs: tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          PromotionList(),
          _TabContent(content: 'Flights Deals'),
          _TabContent(content: 'Trains Deals'),
          _TabContent(content: 'Hotels Deals'),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final String content;

  const _TabContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
