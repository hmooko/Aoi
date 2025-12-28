# Aoi (LearningKanji) - Developer Guide

## Project Overview
**Aoi** is an iOS application designed to help users learn the 2,136 Joyo Kanji designated by the Japanese Ministry of Education. The app features daily recommendations, grade-based learning, quizzes, bookmarks, and search functionality.

**Tech Stack:**
- **Language:** Swift 5+
- **UI Framework:** SwiftUI
- **Persistence:** SwiftData (for user projects/Kanchu), SQLite (implied for static Kanji data), UserDefaults
- **Cloud Sync:** CloudKit (referenced in repositories)
- **Backend/External:** Firebase (configured in App Delegate), potentially Gemini AI integration (referenced in `GeminiModels`).

## Architecture
The project follows a **Clean Architecture** pattern with clear separation of concerns, orchestrated via a Dependency Injection (DI) Container.

### Layers
1.  **Application Layer** (`LearningKanji/Application`)
    -   **Entry Point:** `LearningKanjiApp.swift` initializes the app and the `DIContainer`.
    -   **Dependency Injection:** `DIContainer.swift` is the central hub for creating and providing services, repositories, and use cases. It handles both production and mock implementations.

2.  **Domain Layer** (`LearningKanji/Domain`)
    -   **Entities:** Core data models (e.g., `Kanji`, `KanchuProject`, `Bookmarks`). These are plain Swift structs/classes independent of frameworks.
    -   **Repositories (Protocols):** Interfaces defining data access (e.g., `CommonlyUsedKanjiRepository`, `KanchuProjectRepository`).
    -   **Use Cases (Services):** Business logic encapsulation (e.g., `TodaysKanjiService`, `LearningByGradeService`). They depend on Repository protocols.

3.  **Data Layer** (`LearningKanji/Data`)
    -   **Repositories (Implementations):** Concrete implementations of domain repositories (e.g., `DefaultCommonlyUsedKanjiRepository`). They talk to storage or APIs.
    -   **Data Mapping:** DTOs (Data Transfer Objects) and mappers to convert between API/DB models and Domain entities.
    -   **Storages:** Low-level data access (e.g., `CommonlyUsedKanjiStorage`).

4.  **Presentation Layer** (`LearningKanji/Presentation`)
    -   **Views:** SwiftUI Views (e.g., `HomeView`, `LearningKanjiView`).
    -   **ViewModels:** Manage state and interact with Use Cases.
    -   **Router:** Handles navigation logic.

## Directory Structure & Key Files

```
LearningKanji/
├── Application/
│   ├── DIContainer.swift       # Central Dependency Injection
│   └── LearningKanjiApp.swift  # App Entry
├── Domain/
│   ├── Entities/               # Core Models (Kanji.swift, User.swift)
│   ├── Repositories/           # Protocols for Data Access
│   └── Services/               # Business Logic (Use Cases)
├── Data/
│   ├── Repositories/           # Implementation of Repositories
│   └── Storages/               # Database/Network Helpers
├── Presentation/
│   ├── Home/                   # Home Screen & sub-features
│   ├── Bookmarks/              # Bookmarking features
│   └── Util/                   # Shared UI components & Router
└── Resources/                  # Assets, Fonts, JSON data
```

## Development Workflow

### Adding a New Feature
1.  **Domain:** Define **Entities** and the **Repository Protocol**.
2.  **Use Case:** Create a **Service/UseCase** in `Domain/Services` that implements the business logic, injecting the Repository Protocol.
3.  **Data:** Implement the **Repository** in `Data/Repositories`.
4.  **DI:** Register the new Service and Repository in `DIContainer.swift`.
5.  **Presentation:** Create the **View** and **ViewModel**. Inject the Use Case into the ViewModel via the `DIContainer`.

### Naming Conventions
-   **Services/UseCases:** Suffix with `Service` (e.g., `TodaysKanjiService`).
-   **Repositories:**
    -   Protocol: `NameRepository` (e.g., `CommonlyUsedKanjiRepository`)
    -   Implementation: `DefaultNameRepository` (e.g., `DefaultCommonlyUsedKanjiRepository`)
-   **Views:** Suffix with `View` (e.g., `HomeView`).

## Build & Run

**Requirements:**
-   Xcode 15+ (inferred from SwiftData usage)
-   iOS 17+ (likely target given SwiftData)

**Commands:**
*   **Open Project:**
    ```bash
    open LearningKanji.xcodeproj
    ```
*   **Build (Simulator):**
    ```bash
    xcodebuild -scheme LearningKanji -destination 'platform=iOS Simulator,name=iPhone 15' build
    ```
*   **Test:**
    ```bash
    xcodebuild test -scheme LearningKanji -destination 'platform=iOS Simulator,name=iPhone 15'
    ```

## Testing Strategy
-   **Unit Tests:** Located in `LearningKanjiTests`. Use Mocks defined in `DIContainer` (or separate mock files) to test Use Cases and ViewModels in isolation.
-   **UI Tests:** Located in `LearningKanjiUITests`.
