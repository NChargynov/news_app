import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/news/presentation/adapter/news_paging_adapter.dart';
import 'package:paging_view/paging_view.dart';

import 'widgets/everything_news_card.dart';


@RoutePage()
class EveryThingPage extends StatefulWidget {
  const EveryThingPage({super.key});

  @override
  State<EveryThingPage> createState() => _EveryThingPageState();
}

class _EveryThingPageState extends State<EveryThingPage> {
  late final NewsPagingAdapter pagingAdapter;

  @override
  void initState() {
    pagingAdapter = getIt<NewsPagingAdapter>();
    super.initState();
  }

  @override
  void dispose() {
    pagingAdapter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          child: PagingList.separated(
            padding: EdgeInsets.all(16),
            dataSource: pagingAdapter,
            initialLoadingWidget: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            emptyWidget: Center(child: Text("Нет Данных")),
            separatorBuilder: (_, _) {
              return SizedBox(height: 12);
            },
            appendLoadingWidget: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            errorBuilder: (_, error, _) {
              return Center(child: Text(error.toString()));
            },
            builder: (context, newsEntity, index) {
              return EverythingNewsCard(article: newsEntity);
            },
          ),
          onRefresh: () async {
            pagingAdapter.refresh();
          },
        ),
      ),
    );
  }
}
