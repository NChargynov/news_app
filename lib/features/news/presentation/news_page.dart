import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/everything_news_tile.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    context.read<NewsBloc>().add(GetNewsEvent());
    super.initState();
  }

  Future<void> openBrowser(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Не удалось открыть ссылку: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is LoadedNewsState) {
              return ListView.builder(
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  final NewsEntity news = state.news[index];
                  return EverythingNewsTile(article: news, onTap: () {});
                },
              );
            }
            if (state is ErrorNewsState) {
              return Text(state.message);
            }
            return CircularProgressIndicator.adaptive();
          },
        ),
      ),
    );
  }
}
