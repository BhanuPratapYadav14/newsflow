# NewsFlow - Flutter News Application

**NewsFlow** is a modular, high-performance news application built with Flutter. It utilizes a **Clean Architecture** structure coupled with **GetX State Management** to fetch, search, share, and bookmark articles dynamically using NewsAPI.

---

## 🏗️ Architecture Overview

The project is structured according to **Clean Architecture** principles to enforce strict separation of concerns and maintain a pure core domain layer that is completely independent of external dependencies (such as UI elements, network packages, or local databases).

```
lib/app/
├── core/                                # Core & Global layers
│   ├── constant/                        # App constants (API URLs, keys, images)
│   ├── enums/                           # Global enums (News Category chips)
│   ├── routes/                          # Global routes mapping & PageNames
│   ├── themes/                          # Styling & Color themes
│   ├── domain/                          # Pure business logic layer (No Flutter dependencies)
│   │   ├── entities/                    # Article & Source models
│   │   ├── repositories/                # Abstract repository contracts
│   │   └── usecases/                    # Single-purpose query command interactors
│   ├── data/                            # Implementation layer (API & Database data converters)
│   │   ├── datasources/                 # HTTP Client & Hive Database integrations
│   │   ├── models/                      # Extends domain entities, adds JSON serialization
│   │   └── repositories/                # Repository implementations coordinating data sources
│   └── utils/                           # Formatting utils and developer logging wrappers
│
└── features/                            # Presentation UI features (Bindings, Controllers, Pages, Widgets)
    ├── splashScreen/                    # Initial loader animation page
    ├── homeScreen/                      # Homepage with category chips & headlines list
    ├── newsListScreen/                  # "See All" articles feed page with infinite scrolling
    ├── articleDetail/                   # WebReader reading screen
    ├── bookmarks/                       # Saved articles overview screen
    └── search/                          # Article search query screen
```

---

## 🛠️ Software Design Patterns Used

* **MVVM (Model-View-ViewModel)**: Segregates UI elements (Views) from the business controller logic (ViewModels) via GetX controllers.
* **Observer Pattern**: Binds reactive variables (`RxList`, `RxBool`) to screen layouts. Tapping bookmarks or loading items triggers localized, low-overhead visual redraws automatically.
* **Service Locator & Dependency Injection (DI)**: GetX handles object lifecycles globally, instantiating dependency instances lazily when routes are pushed and purging them on pop.
* **Repository Pattern**: Abstract repository interfaces define data contracts in the Domain layer, while concrete implementations in the Data layer decide whether to pull from the cloud or read from local storage.
* **Singleton Pattern**: The Hive database boxes and global controllers (like `BookmarkController`) run as singletons to guarantee a single source of truth across all modules.

---

## 📦 Third-Party Libraries Utilized

* **`get` (State Management & Routing)**: Drives low-overhead reactive visual updates, dependency injections, and path routing.
* **`http` (Remote REST Networking)**: Executes secure HTTPS communication to fetch news feeds.
* **`hive_flutter` (Local Database)**: Fast, lightweight, no-SQL database engine used to cache and restore bookmarks offline.
* **`share_plus` (System Sharing)**: Calls native platform APIs to share news articles with friends.
* **`webview_flutter` (Embedded Reading)**: Renders the full article content cleanly inside a native browser shell.
* **`logger` (Formatting Console Logger)**: Outputs colored, readable log prints exclusively in `kDebugMode`.

---

## 🚀 How to Build and Run the App

### Prerequisites
1. Ensure the **Flutter SDK** (v3.12.0 or higher) is installed. Check by running:
   ```bash
   flutter --version
   ```
2. Obtain a free API Key from [NewsAPI](https://newsapi.org/).

### Setup Instructions
1. Clone or download the source code repository.
2. Navigate to the project root directory in your terminal and fetch packages:
   ```bash
   flutter pub get
   ```
3. Open `lib/app/core/constant/appConstant.dart` and insert your NewsAPI Key:
   ```dart
   class AppConstant {
     static const String API_KEY = 'YOUR_NEWS_API_KEY_HERE';
     static const String BASE_URL = 'https://newsapi.org/v2/';
   }
   ```

### Execution Steps
* To list available devices connected to your machine:
  ```bash
  flutter devices
  ```
* To compile and run the application on your selected target (Android, iOS, or Emulator):
  ```bash
  flutter run
  ```
