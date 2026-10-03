# News App

Flutter-приложение для Android и iOS, которое загружает новости о футболе из NewsAPI и отображает их в ленте карточек. Проект организован по функциональным модулям с разделением на слои `data`, `domain` и `ui`.

Версия приложения в `pubspec.yaml`: `1.0.0+1`.

## Возможности

- Автоматическая загрузка новостей при открытии главного экрана.
- Карточки с изображением, заголовком, описанием, автором и датой публикации.
- Индикатор загрузки и сообщение «Новостей нет» при ошибке запроса или обработки данных.
- Заглушка при ошибке загрузки изображения; при отсутствии URL блок изображения не отображается.
- Логирование HTTP-запросов и ответов через Talker.

Сейчас в приложении один экран. Поиск, выбор категории, пагинация, обновление жестом, повторная загрузка по кнопке, избранное, офлайн-кеш и открытие полной статьи не реализованы. Дата публикации выводится в исходном формате API. Успешный ответ с пустым списком отображается как пустая лента без отдельного сообщения.

## Технологии

Ограничения версий ниже взяты из `pubspec.yaml`; конкретные версии зависимостей зафиксированы в `pubspec.lock`.

| Пакет | Версия | Назначение |
| --- | --- | --- |
| Flutter / Dart | Dart `^3.13.2` | Интерфейс на Material и логика приложения |
| `flutter_bloc` | `^9.1.1` | События, состояния и обновление UI |
| `equatable` | `^3.0.0` | Сравнение событий и состояний |
| `dio` | `^5.11.1` | HTTP-клиент |
| `get_it` | `^9.3.0` | Контейнер зависимостей |
| `injectable` | `^3.0.0` | Аннотации для регистрации зависимостей |
| `injectable_generator` | `^3.1.3` | Генерация конфигурации DI |
| `build_runner` | `^2.16.1` | Запуск генераторов |
| `talker_flutter`, `talker_dio_logger` | `^5.1.20` | Логирование и интеграция с Dio |
| `flutter_lints` | `^6.0.0` | Правила статического анализа |

Также подключены `cupertino_icons` и `flutter_test`. Отдельный экран просмотра логов в приложении не настроен.

## Структура проекта

```text
lib/
├── main.dart                         # Инициализация DI и запуск MaterialApp
├── core/
│   └── di/
│       ├── service_locator.dart      # GetIt, Injectable, Dio и Talker
│       └── service_locator.config.dart # Генерируется локально, исключён из Git
└── features/
    └── news/
        ├── data/
        │   ├── model/
        │   │   └── news_article_model.dart
        │   ├── remote/
        │   │   ├── api/news_data_source.dart
        │   │   └── impl/news_data_source_impl.dart
        │   └── repo_impl/news_repository_impl.dart
        ├── domain/
        │   ├── entity/news_article_entity.dart
        │   └── repo/news_repository.dart
        └── ui/
            ├── bloc/
            │   ├── news_bloc.dart
            │   ├── news_event.dart
            │   └── news_state.dart
            └── presentation/
                ├── home_page.dart
                └── widgets/article_tile.dart
android/                              # Android-проект и настройки Gradle
ios/                                  # iOS-проект и настройки Xcode
analysis_options.yaml                 # Настройки анализатора
pubspec.yaml                          # Метаданные и зависимости
pubspec.lock                          # Зафиксированные версии зависимостей
```

Платформенные проекты для Web, Windows, Linux и macOS отсутствуют.

## Архитектура и поток данных

`domain` содержит сущность статьи и контракт репозитория, без зависимостей от Flutter и сетевых библиотек. `data` выполняет HTTP-запрос, разбирает JSON и преобразует модели в сущности. `ui` содержит BLoC, экран и виджеты. Отдельного слоя use case нет: BLoC обращается к интерфейсу репозитория напрямую.

```text
HomePage → GetEverythingEvent → NewsBloc
                                  ↓
                           NewsRepository
                                  ↓
                         NewsRepositoryImpl
                                  ↓
                          NewsDataSourceImpl
                                  ↓
                              Dio → NewsAPI

JSON → NewsArticleModel → NewsArticleEntity → NewsSuccess → ArticleTile
```

1. `main()` ожидает `setupServiceLocator()` и запускает `MyApp`.
2. `HomePage` получает `NewsBloc` из GetIt через `BlocProvider` и отправляет `GetEverythingEvent`.
3. BLoC меняет состояние с `NewsInitial` на `NewsLoading` и вызывает `getEverythingArticles()` у репозитория.
4. Источник данных читает массив `articles` из ответа, репозиторий преобразует модели в сущности.
5. При успехе BLoC выдаёт `NewsSuccess`, при исключении — `NewsFailure`. `BlocBuilder` перестраивает экран.

Поля модели допускают `null`. При преобразовании в сущность отсутствующий автор заменяется на «Нету автора», остальные отсутствующие строки — на пустую строку. Поля `url` и `content` сохраняются, но в интерфейсе пока не используются.

Регистрация зависимостей описана в [service_locator.dart](lib/core/di/service_locator.dart) и аннотациях классов:

- `Talker` и `Dio` — singleton.
- `NewsDataSource` и `NewsRepository` — lazy singleton.
- `NewsBloc` — factory: новый экземпляр при каждом запросе из контейнера.

## Требования

- Flutter SDK с Dart `>=3.13.2 <4.0.0`. В `pubspec.lock` дополнительно указано Flutter `>=3.38.4`; выбранный SDK должен удовлетворять обоим ограничениям. Конкретная версия Flutter через FVM в репозитории не закреплена.
- Для Android: Android SDK, настроенная Java для Gradle и эмулятор либо устройство. В проекте используются Gradle `9.3.1`, Android Gradle Plugin `9.1.0`, а целевая версия Java/Kotlin bytecode — 17. Значения `compileSdk`, `minSdk`, `targetSdk` и NDK берутся из Flutter SDK.
- Для iOS: macOS, Xcode и симулятор либо устройство с iOS 15.0 или новее. В Xcode-проекте подключён `FlutterGeneratedPluginSwiftPackage`; `Podfile` в репозитории отсутствует.
- Действующий ключ NewsAPI и доступ к интернету.

## Настройка API

Базовый адрес и таймауты находятся в [service_locator.dart](lib/core/di/service_locator.dart):

```text
Base URL:        https://newsapi.org/v2/
Connect timeout: 10 секунд
Receive timeout: 10 секунд
```

Параметры запроса заданы в классе `_ApiPath` в [news_data_source_impl.dart](lib/features/news/data/remote/impl/news_data_source_impl.dart):

| Параметр | Текущее значение |
| --- | --- |
| Метод и endpoint | `GET /v2/everything` |
| `q` | `football` |
| `from` | `2026-08-30` |
| `sortBy` | `publishedAt` |
| `apiKey` | Значение `_ApiPath.apiKey` |

Перед запуском задайте собственный ключ в `_ApiPath.apiKey` локально и проверьте дату `from` с учётом доступного вашему ключу диапазона данных. Дата зафиксирована в коде и автоматически не обновляется. Тему запроса можно изменить через `q` в той же строке.

Текущая реализация хранит ключ непосредственно в исходнике и передаёт его в URL. Загрузка из `.env` или `--dart-define` не реализована. Не включайте собственный ключ в коммиты и публичные логи. Настройка `hiddenHeaders: {'X-Api-Key'}` не скрывает ключ из query-параметров URL; при публикации проекта существующий ключ следует заменить, а способ конфигурации — переработать.

## Запуск

Выполните команды из корня проекта после настройки API:

```bash
flutter --version
flutter doctor
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter devices
flutter run -d <device_id>
```

Замените `<device_id>` на идентификатор Android- или iOS-устройства из `flutter devices`. Если доступно одно подходящее устройство, достаточно `flutter run`.

Генерация обязательна после клонирования: `service_locator.dart` импортирует `service_locator.config.dart`, а файлы `*.config.dart` исключены из Git. Генерируемый файл не нужно редактировать вручную. Повторяйте генерацию после изменения DI-аннотаций или конструкторов зависимостей.

Для автоматической генерации во время разработки:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Для запуска на физическом iOS-устройстве откройте `ios/Runner.xcworkspace` в Xcode и выберите свою команду в Signing & Capabilities. В проекте уже задана команда разработчика, которую может потребоваться изменить. Bundle identifier iOS — `com.geeks.app.newsApp`, application ID Android — `com.geeks.app.news_app`.

## Проверка кода

После установки зависимостей и генерации DI:

```bash
flutter analyze
dart format --output=none --set-exit-if-changed lib
```

Правила анализа подключены из `flutter_lints`; каталоги `build`, `android` и `ios` исключены из Dart-анализа.

Каталогов `test/` и `integration_test/` сейчас нет. В `ios/RunnerTests` находится только шаблонный тест без проверок поведения приложения. После добавления Flutter-тестов их можно запускать командой `flutter test`.

## Сборка

Для проверочной Android-сборки после настройки API и генерации DI:

```bash
flutter build apk --debug
```

APK появится в `build/app/outputs/flutter-apk/app-debug.apk`.

Перед Android release-сборкой нужно добавить разрешение в `android/app/src/main/AndroidManifest.xml` внутри `<manifest>`, перед `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Сейчас оно указано только в манифестах `debug` и `profile`. Также настройте собственную release-подпись в `android/app/build.gradle.kts`: текущая конфигурация использует debug-ключ.

После этих изменений команды для Android:

```bash
flutter build apk --release
flutter build appbundle --release
```

Для проверки iOS-сборки на macOS без подписи:

```bash
flutter build ios --release --no-codesign
```

Для установки на физическое устройство или распространения iOS-приложения потребуется настроенная подпись.

## Частые проблемы

| Симптом | Что проверить |
| --- | --- |
| Не найден `service_locator.config.dart` | Выполните `flutter pub get` и генерацию через `build_runner` |
| Ошибка ограничения версии Dart | Проверьте Dart, поставляемый с выбранным Flutter SDK: нужен `>=3.13.2 <4.0.0` |
| На экране «Новостей нет» | Проверьте соединение, ключ, дату запроса и HTTP-ответ в логах Talker; BLoC показывает одно сообщение для всех исключений |
| Пустой экран после успешного запроса | Проверьте массив `articles`: для пустого результата отдельное состояние UI не предусмотрено |
| Android debug работает с сетью, release — нет | Добавьте `INTERNET` в основной Android-манифест |
| Ошибка подписи iOS | Выберите доступную вам команду разработчика и при необходимости измените bundle identifier в Xcode |

Документация описывает текущий код и конфигурацию проекта. Успешность запросов к NewsAPI зависит от действующего ключа и доступности сервиса.
