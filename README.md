# SkyCast - Weather Application 🌤️

A production-grade, beautifully animated weather forecasting application built using **Flutter**. This application relies on a strict implementation of **Clean Architecture** allowing it to scale securely, be exhaustively tested, and perform synchronously at 60 FPS under varying network contexts.

## 📱 Features
- **Clean Architecture Hierarchy** (Presentation ➔ Domain ➔ Data layers perfectly isolated).
- **Offline First Methodology**: Stores all search results locally inside SQLite databases allowing full app traversals devoid of internet connection natively.
- **60 FPS Performance**: Complete structural stateless optimizations, `itemExtent` algorithms, and `cached_network_image` preventing repaint boundaries breaking.
- **Lottie Integrations**: Fluid loading UI animations intercepting heavy backend delays.
- **Dynamic Testing Matrix**: Heavily covered via pure Dart Unit tests, localized Widget bounding tests, and `integration_test` E2E suites.



## 📱 Screenshots
<div align="center">
  <table border="0">
    <tr>
      <td width="48%" align="center" valign="top">
          <img src="https://github.com/user-attachments/assets/ec37bf41-17a5-4c84-8c0b-7f80633f297f" width="100%" />
        </a>
        <br><br>
        <a href="https://github.com/oOSatyamOo/GitHub-Language-Stats">
          <img src="https://github.com/user-attachments/assets/2ca1415f-d31d-435d-98ed-65a259bb0fb5" width="100%" />
        </a>
      </td>
       <td width="48%" align="center" valign="top">
          <img src="https://github.com/user-attachments/assets/0ec34cce-3828-43a3-b155-3cb8eb0871dd" width="100%" />
        </a>
        <br><br>
        <a href="https://github.com/oOSatyamOo/GitHub-Language-Stats">
          <img src="https://github.com/user-attachments/assets/177bfc47-cd0b-48dc-af86-e7f045275e52" width="100%" />
        </a>
      </td>
    </tr>
  </table>
</div>


---

## 🏗️ Architecture
We strictly follow **Clean Architecture** combined with **SOLID principles**:
1. **Presentation**: Defines UI (Widgets) and State Management (`flutter_bloc` / `Cubits`). Cubits parse simple user intent directly into Domain UseCases.
2. **Domain**: The core bounds. Encompasses Enterprise `Entities`, specific `UseCases`, and isolated Interface contracts. The domain depends on absolutely *nothing* implicitly outside itself.
3. **Data**: Isolates `Repositories` pulling interfaces together. Coordinates routing fetches natively towards endpoints (Dio) or local database caching sources (`sqflite`).

```
flutter_forcast/
    ├── assets/
    │   ├── showSearchWaiting.json
    ├── lib/
    │   ├── core/
    │   │   ├── di/
    │   │   │   ├── injection_container.dart
    │   │   ├── error/
    │   │   │   ├── exceptions.dart
    │   │   │   ├── failures.dart
    │   │   ├── network/
    │   │   │   ├── dio_client.dart
    │   │   │   ├── network_info.dart
    │   │   ├── theme/
    │   │   │   ├── app_theme.dart
    │   │   ├── utils/
    │   │   │   ├── lottie_assets.dart
    │   │   ├── widgets/
    │   │   │   ├── common_widgets.dart
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── weather_local_data_source.dart
    │   │   │   ├── weather_remote_data_source.dart
    │   │   ├── models/
    │   │   │   ├── city_model.dart
    │   │   │   ├── weather_forecast_model.dart
    │   │   ├── repositories/
    │   │   │   ├── weather_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── city.dart
    │   │   │   ├── weather_forecast.dart
    │   │   ├── repositories/
    │   │   │   ├── weather_repository.dart
    │   │   ├── usecases/
    │   │   │   ├── get_forecast_usecase.dart
    │   ├── presentation/
    │   │   ├── blocs/
    │   │   │   ├── weather/
    │   │   │   │   ├── weather_cubit.dart
    │   │   │   │   ├── weather_state.dart
    │   │   ├── pages/
    │   │   │   ├── details_page.dart
    │   │   │   ├── home_page.dart
    │   ├── main.dart
    ├── test/
    │   ├── core/
    │   │   ├── network/
    │   │   │   ├── network_info_test.dart
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── city_model_test.dart
    │   ├── domain/
    │   │   ├── usecases/
    │   │   │   ├── get_forecast_usecase_test.dart
    │   ├── integration_test/
    │   │   ├── app_test.dart
    │   ├── presentation/
    │   │   ├── blocs/
    │   │   │   ├── weather_cubit_test.dart
    │   │   ├── pages/
    │   │   │   ├── home_page_test.dart
    │   ├── widget_test.dart
    ├── .gitignore
    ├── AI_LOG.md
    ├── analysis_options.yaml
    ├── ARCHITECTURE.md
    ├── LICENSE
    ├── pubspec.yaml
    ├── README.md
    ├── REVIEW_LOG.md
    └── skycast.iml
```
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

## 🚀 How to Run the Project

### Prerequisites
- Android Studio Meerkat | Ladybug | or newer
- Minimum SDK: 24 (Android 7.0)
- An API key from [OpenWeatherMap](https://openweathermap.org/api)
- add API KEY in .env file where your pubspec.ymal is at the root 
   ```
   API_KEY=KEY
  BASE_URL=https://api.openweathermap.org/data/2.5
  DB_NAME=YOUR_DB_NAME
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


Adding a new localization message is a straightforward process thanks to the .arb (Application Resource Bundle) architecture we set up. Here are the steps:

1. Add the string to the base English file
Open your primary template file, which is lib/l10n/app_en.arb. Add your new key and string at the bottom (make sure to format it as proper JSON).

json
"myNewMessage": "This is a new message!"
If you need variables/placeholders: You define the string with {variableName} and then add an @ metadata object underneath it to define the type.

json
"welcomeUser": "Welcome, {name}!",
  "@welcomeUser": {
    "placeholders": {
      "name": { "type": "String" }
    }
  }
2. Add the translations to the other locale files
Open the remaining translation files:

app_hi.arb (Hindi)
app_ta.arb (Tamil)
app_ru.arb (Russian)
app_ja.arb (Japanese)
Add the exact same key (myNewMessage) but with the translated text. If you forget to add the key to one of these files, Flutter will throw a build error, which is a great safety net!

3. Generate the Dart code
Once you save the .arb files, Flutter needs to regenerate the AppLocalizations Dart class so your code knows the new string exists. Run this command in your terminal:

bash
flutter gen-l10n
(Note: If you are actively running the app, sometimes just hitting save or running flutter pub get will trigger the code generation automatically depending on your IDE).

4. Use it in your UI
Now you can safely access your new localized string from any widget's build method using the context extension we created:

dart
Text(context.l10n.myNewMessage)
// Or if it has placeholders:
Text(context.l10n.welcomeUser('Satyam'))