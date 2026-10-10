import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/ui/adapter/everything_paging_adapter.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/bloc/news_state.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';
import 'package:paging_view/paging_view.dart';

import 'widgets/everything_news_tile.dart';

class EverythingPage extends StatefulWidget {
  const EverythingPage({super.key});

  @override
  State<EverythingPage> createState() => _EverythingPageState();
}

class _EverythingPageState extends State<EverythingPage> {
  final EverythingPagingAdapter pagingAdapter =
      getIt<EverythingPagingAdapter>();

  @override
  void dispose() {
    pagingAdapter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewsHomeStyle.background,
      appBar: AppBar(
        title: const Text('Все новости', style: NewsHomeStyle.subtitle),
        backgroundColor: NewsHomeStyle.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pagingAdapter.refresh();
        },
        child: PagingList<int, NewsArticleEntity>.separated(
          dataSource: pagingAdapter,
          emptyWidget: Center(child: Text("Нет Данных")),
          initialLoadingWidget: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          appendLoadingWidget: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          errorBuilder: (_, error, _) {
            return Center(child: Text(error.toString()));
          },
          builder: (context, article, pos) {
            return EverythingNewsTile(article: article, onTap: () {});
          },
          separatorBuilder: (_, _) {
            return const SizedBox(height: 12);
          },
        ),
      ),
    );
  }
}
