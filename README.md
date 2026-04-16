# SkyCast - Weather Application 🌤️

A production-grade, beautifully animated weather forecasting application built using **Flutter**. This application relies on a strict implementation of **Clean Architecture** allowing it to scale securely, be exhaustively tested, and perform synchronously at 60 FPS under varying network contexts.

## 📱 Features
- **Clean Architecture Hierarchy** (Presentation ➔ Domain ➔ Data layers perfectly isolated).
- **Offline First Methodology**: Stores all search results locally inside SQLite databases allowing full app traversals devoid of internet connection natively.
- **60 FPS Performance**: Complete structural stateless optimizations, `itemExtent` algorithms, and `cached_network_image` preventing repaint boundaries breaking.
- **Lottie Integrations**: Fluid loading UI animations intercepting heavy backend delays.
- **Dynamic Testing Matrix**: Heavily covered via pure Dart Unit tests, localized Widget bounding tests, and `integration_test` E2E suites.

---

## 🏗️ Architecture
We strictly follow **Clean Architecture** combined with **SOLID principles**:
1. **Presentation**: Defines UI (Widgets) and State Management (`flutter_bloc` / `Cubits`). Cubits parse simple user intent directly into Domain UseCases.
2. **Domain**: The core bounds. Encompasses Enterprise `Entities`, specific `UseCases`, and isolated Interface contracts. The domain depends on absolutely *nothing* implicitly outside itself.
3. **Data**: Isolates `Repositories` pulling interfaces together. Coordinates routing fetches natively towards endpoints (Dio) or local database caching sources (`sqflite`).

---

## 🛠️ Technology Stack
- **Framework**: [Flutter](https://flutter.dev/) (SDK 3.41.6)
- **Design System**: Material 3 (Dynamically themed)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Networking/HTTP**: [dio](https://pub.dev/packages/dio) & internet_connection_checker_plus
- **Local Database**: [sqflite](https://pub.dev/packages/sqflite)
- **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart) (For `Either` implementations handling explicit Failures)
- **Environment**: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)

---

## 🚀 Getting Started

### 1. Requirements
Ensure your environment is set up.
*   Flutter version **3.41.6** or higher.
*   Dart version **3.11.4** or higher.

### 2. Environment Configuration
For security, API Keys are explicitly omitted from this Github.
1. Create a `.env` file at the root of the project directory.
2. Add your OpenWeatherMap credentials mapping exactly as below:
```env
API_KEY=your_openweathermap_api_key_here
BASE_URL=https://api.openweathermap.org/data/2.5
DB_NAME=weather.db
```

### 3. Build & Run
From the root of the repository, execute:
```bash
flutter pub get
flutter run
```

---

## 🧪 Testing Guidelines
SkyCast leverages all test tiers verifying architectural bounds natively.

**Unit & Widget Testing (Fast)**
Verifies mappings, debouncing, stateless boundaries, and business rules without requiring an emulator payload.
```bash
flutter test
```

**Integration Testing (E2E)**
Verifies explicit routing paths opening the emulator and tapping/navigating routes manually triggering debounces.
```bash
flutter test integration_test/app_test.dart
```

---

*Documentation explicitly prepared for developer handovers. Review specific subsystem logic within the inline class comments.*
