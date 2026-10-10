import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/bloc/news_state.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';

import 'widgets/everything_news_tile.dart';

class EverythingPage extends StatelessWidget {
  const EverythingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewsHomeStyle.background,
      appBar: AppBar(
        title: const Text('Все новости', style: NewsHomeStyle.subtitle),
        backgroundColor: NewsHomeStyle.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsSuccess) {
            if (state.news.isEmpty) {
              return const Center(
                child: Text('Новостей пока нет', style: NewsHomeStyle.search),
              );
            }
            return ListView.separated(
              key: const PageStorageKey('everything-news'),
              padding: const EdgeInsets.all(NewsHomeStyle.horizontalPadding),
              itemCount: state.news.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 32, color: NewsHomeStyle.divider),
              itemBuilder: (context, index) {
                final article = state.news[index];
                return EverythingNewsTile(article: article, onTap: () {});
              },
            );
          }
          if (state is NewsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(NewsHomeStyle.horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, style: NewsHomeStyle.search),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.read<NewsBloc>().add(
                        const GetEverythingEvent(),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: NewsHomeStyle.text,
                      ),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: NewsHomeStyle.text),
          );
        },
      ),
    );
  }
}
