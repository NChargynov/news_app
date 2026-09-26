import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/repo/news_repository.dart';
import 'package:news_app/ui/bloc/news_bloc.dart';
import 'package:news_app/ui/bloc/news_event.dart';
import 'package:news_app/ui/bloc/news_state.dart';
import 'package:news_app/ui/presentation/widgets/article_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.newsRepository});

  final NewsRepository newsRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) =>
              NewsBloc(newsRepository: newsRepository)..add(GetEverythingEvent()),
          child: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state is NewsLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is NewsFailure) {
                return Center(child: Text(state.message));
              }
              if (state is NewsSuccess) {
                final list = state.news;

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, pos) {
                    final article = list[pos];
                    return ArticleTile(article: article);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
