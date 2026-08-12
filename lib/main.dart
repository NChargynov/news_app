import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/news/data/data_source/abstract/news_data_source.dart';
import 'package:news_app/features/news/data/data_source/remote/news_data_source_impl.dart';
import 'package:news_app/features/news/data/repository/news_repository_impl.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';
import 'package:news_app/features/news/domain/use_case/get_news_use_case.dart';

import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/news/presentation/news_page.dart';

void main() async{
  await setupServiceLocator();
  runApp(
    MaterialApp(home: NewsPage()),
  );
}
