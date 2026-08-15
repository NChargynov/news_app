# News App

Flutter-приложение для загрузки и отображения списка спортивных новостей из
[NewsAPI](https://newsapi.org/). Текущая версия содержит один экран: он запрашивает
статьи, показывает состояние загрузки или ошибки и выводит карточки с изображением,
заголовком, описанием, автором и датой публикации.

Версия приложения: `1.0.0+1`.

## Технологический стек

| Задача | Решение |
| --- | --- |
| UI | Flutter, Material |
| State management | `flutter_bloc` |
| HTTP-клиент | `dio` |
| Dependency injection | `get_it`, `injectable` |
| Генерация DI-конфигурации | `injectable_generator`, `build_runner` |
| Логирование HTTP | `talker`, `talker_dio_logger`, `talker_flutter` |
| Открытие внешних ссылок | `url_launcher` |
| Статический анализ | `flutter_lints` |

## Требования

- Flutter `>=3.38.4`.
- Dart `>=3.10.4 <4.0.0`.
- Для Android: JDK 17. Проект использует Android Gradle Plugin `8.11.1`,
  Kotlin `2.2.20` и Gradle `8.14`.
- Для iOS: macOS, Xcode и CocoaPods. Deployment target проекта — iOS 13.0.

## Установка и запуск

Из корня проекта установите зависимости и сгенерируйте DI-конфигурацию:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Проверьте доступные устройства и запустите приложение:

```bash
flutter devices
flutter run
```

Для выбора конкретного устройства:

```bash
flutter run -d <device_id>
```

Точка входа — `lib/main.dart`. Перед `runApp` вызывается
`setupServiceLocator()`, после чего `NewsPage` устанавливается как
`MaterialApp.home`.

## Конфигурация окружения

Flavors, `.env`-файлы и `--dart-define` в проекте не настроены. Используется одна
конфигурация приложения:

- base URL `https://newsapi.org/` и таймауты по 10 секунд заданы в
  `lib/core/di/service_locator.dart`;
- путь запроса, параметры фильтрации, фиксированные даты и API key находятся в
  `lib/features/news/data/data_source/remote/news_data_source_impl.dart`.

Дополнительный конфигурационный файл для первого запуска создавать не требуется.
Доступность данных зависит от актуальности параметров и ключа NewsAPI, находящихся
в исходном коде.

## Архитектура и структура проекта

Код организован по feature-first подходу с разделением feature `news` на слои
`data`, `domain` и `presentation`:

```text
lib/
├── core/
│   └── di/
│       ├── service_locator.dart
│       └── service_locator.config.dart
├── features/
│   └── news/
│       ├── data/
│       │   ├── data_source/
│       │   ├── models/
│       │   └── repository/
│       ├── domain/
│       │   ├── models/
│       │   ├── repository/
│       │   └── use_case/
│       └── presentation/
│           ├── bloc/
│           ├── widgets/
│           └── news_page.dart
└── main.dart
```

Поток получения данных:

```text
NewsPage → NewsBloc → GetNewsUseCase → NewsRepository
         → NewsDataSource → Dio → NewsAPI
```

- **Data layer** выполняет REST-запрос, преобразует JSON в `NewsModel`, а затем
  маппит nullable-поля модели в `NewsEntity`.
- **Domain layer** содержит `NewsEntity`, контракт `NewsRepository` и
  `GetNewsUseCase`.
- **Presentation layer** содержит экран, BLoC, события, состояния и UI карточки
  новости.

## Основной функционал

- запрос статей через endpoint `GET /v2/everything` с поиском по теме `sport` и
  сортировкой по популярности;
- отображение списка новостей после успешной загрузки;
- adaptive progress indicator во время запроса;
- состояние ошибки при исключении в цепочке загрузки;
- загрузка изображений через `Image.network` с fallback-иконкой;
- отображение заголовка, описания, автора и времени публикации.

В `NewsPage` есть helper для открытия URL через `url_launcher`, однако нажатие на
карточку сейчас передаёт пустой callback, поэтому переход к статье не подключён.

## State management и DI

`NewsPage` создаёт `NewsBloc` через `BlocProvider` и сразу отправляет
`GetNewsEvent`. UI в `BlocBuilder` обрабатывает состояния `NewsInitial`,
`LoadingNewsState`, `LoadedNewsState` и `ErrorNewsState`.

Контейнер `get_it` конфигурируется через `injectable`:

- `Talker` и `Dio` регистрируются как singleton;
- data source, repository и use case — как lazy singleton;
- `NewsBloc` — как factory.

HTTP-запросы и ответы логируются интерцептором `TalkerDioLogger`.

## Code generation

`lib/core/di/service_locator.config.dart` генерируется из аннотаций
`injectable` и исключён из Git правилом `*.config.dart`. Поэтому команду нужно
выполнить после первого клонирования, а также после добавления или изменения
DI-регистраций:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Сгенерированный файл не следует редактировать вручную.

## Навигация

Отдельный router и named routes отсутствуют. Приложение состоит из одного
`NewsPage`, указанного в `MaterialApp.home`.

## Assets и локализация

- В `pubspec.yaml` включены Material Icons через `uses-material-design: true`.
- Flutter assets и пользовательские шрифты не объявлены.
- Android launcher icons и iOS AppIcon/LaunchImage находятся в нативных каталогах
  платформ.
- ARB-файлы и Flutter localization не настроены; строки заданы непосредственно в
  Dart-коде.

## Особенности платформ

### Android

- Application ID и namespace: `com.geeks.newsapp.news_app`.
- `compileSdk`, `minSdk` и `targetSdk` берутся из конфигурации установленного
  Flutter SDK.
- Release build сейчас подписывается debug-ключом.
- Разрешение `android.permission.INTERNET` объявлено только в debug/profile
  manifests. В текущей конфигурации release-сборка не имеет сетевого разрешения,
  необходимого для загрузки новостей.

### iOS

- Bundle ID: `com.geeks.newsapp.newsApp`.
- Deployment target: iOS 13.0.
- В Xcode-проекте используется automatic signing, а в `Podfile` включён
  `use_frameworks!`.

## Сборка

Android:

```bash
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

iOS:

```bash
flutter build ios --debug
flutter build ios --release
```

Для iOS release-сборки необходима корректная локальная настройка signing в Xcode.

## Полезные команды

```bash
# Статический анализ
flutter analyze

# Очистка артефактов и повторная установка зависимостей
flutter clean
flutter pub get

# Повторная генерация DI-конфигурации
dart run build_runner build --delete-conflicting-outputs
```

Пользовательские scripts для разработки и каталог `test/` в репозитории сейчас
отсутствуют. В `ios/RunnerTests` сохранён стандартный нативный тестовый target.
