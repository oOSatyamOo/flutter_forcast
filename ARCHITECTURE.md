###
Why Clean Architecture (Presentation → Domain → Data)?
Clean Architecture (inspired by Uncle Bob / Robert C. Martin) was chosen because it enforces separation of concerns, making the codebase:

Testable — Business logic (domain) can be unit-tested independently without mocking UI or database.
Maintainable & Scalable — Changes to the UI, API, or local storage (e.g., switching from sqflite to another DB) do not affect other layers.
Flexible — The core (domain entities and use cases) remains stable even if external frameworks or services change.
Follows SOLID principles — Especially Single Responsibility Principle (SRP), Dependency Inversion, and Open/Closed.

For this simple SkyCast weather app, even though the scope is small, Clean Architecture demonstrates production-level thinking. It keeps the code organized, prevents business logic from leaking into the UI, and makes it easy to add features later (e.g., multiple cities, unit conversion, etc.).
Layer Responsibilities:

Presentation: Handles UI, user interactions, and state (only talks to Cubit).
Domain: Pure business logic, entities, and Use Cases (the heart of the app).
Data: Implementation details (remote API + local sqflite persistence).

This structure ensures the app is framework-independent at its core.


###
Why flutter_bloc (Cubit) as State Management?
We chose flutter_bloc with Cubit (instead of full Bloc) for the following reasons:

Explicit and predictable state flow — Perfect for Clean Architecture. The Cubit acts as a ViewModel (MVVM-style), emitting states that the UI reacts to.
Excellent integration with Clean Architecture — Cubits stay thin: they only orchestrate Use Cases and handle UI-specific logic (loading, error, success states).
Built-in support for loading/error states — Very useful for a weather app that deals with network calls and offline scenarios.
Testability — Easy to test Cubits by injecting mocked Use Cases.
Industry adoption — Widely used in production Flutter apps, has great dev tools (BlocObserver, debugger extensions), and forces good structure.

Cubit vs full Bloc: Since most actions in this app are simple (fetch weather, search with debounce), Cubit keeps boilerplate low while still providing clear state management. We only use full Bloc if complex event handling is needed in the future.
Alternatives considered:

Provider/Riverpod: Simpler for very small apps, but less "structured" for enforcing Clean Architecture.
GetX: Fast but can lead to less clean separation if not disciplined.

flutter_bloc + Clean Architecture gives the best balance of structure and simplicity for this assignment.

###
Why Use Cases in the Domain Layer?
Use Cases (or Interactors) encapsulate single business actions (e.g., GetWeatherForecastUseCase, SaveWeatherToCacheUseCase).
Benefits:

Keeps Cubits clean and focused only on UI orchestration.
Reusability — The same Use Case can be called from different screens or even future widgets.
Testability — Each Use Case does one thing and can be tested in isolation.
Self-documenting — Reading GetWeatherForecastUseCase clearly shows what the app’s business rule is.
SRP compliance — No mixing of concerns (e.g., fetching + caching logic is separated if needed).

For a weather app, this is especially useful because we combine remote API data with local cache logic inside Use Cases.

###
Data Layer Approach (Remote + Local with sqflite)

Repository Pattern (abstract repository in domain, concrete impl in data) → Allows easy switching between data sources.
Online/Offline Strategy:
Try remote API first.
On success → save to sqflite.
On failure (no internet) → load last saved data from sqflite.

Why sqflite (SQLite) instead of Hive?Aspectsqflite Choice ReasonHive AlternativeData StructureStructured forecast data (daily + 3-hour slots)Better for simple key-value objectsQuery FlexibilitySQL allows easy filtering by date/cityNo native complex queriesRelational FutureEasier to expand (e.g., multiple cities table)Less suitable for relationsAssignment FitDemonstrates proper DAO + SQL usageFaster but simplersqflite gives more "engineering" depth for the assessment while still being lightweight for this small app.
Remote DataSource: Uses http package with proper logging for every API call.
Local DataSource: DAO pattern with proper models and mappers (data models → domain entities).

###
Other Key Decisions

go_router: Clean, type-safe, declarative navigation (better than Navigator 2.0 raw usage).
get_it: Simple, lightweight dependency injection. Keeps layers loosely coupled.
freezed: Immutable models and states → safer, less boilerplate for copyWith/equality.
Material 3 + Shared AppTheme: Ensures consistent, beautiful, responsive UI with professional color palette and full dark mode support.
connectivity_plus: For detecting online/offline status.

This architecture makes the app well-architected, testable, and maintainable while keeping the scope small — exactly what the assignment asks for.
Reflection: Even for a simple 2-screen weather app, this structure prevents technical debt and shows I can think like a senior engineer. If the app grows (add favorites, alerts, unit settings), the foundation is already solid.
