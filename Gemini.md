# 지켜야할 부분
- 코드 작성 시 최대한 현재 프로젝트의 아키텍처를 따를 것
- UseCase 혹은 Repository를 생성하거나 변경사항이 있다면 이를 DIContainer에 항상 적용해야 함 
- 코드를 실제로 바꾸기 전에 먼저 어떻게 바꿀건지 전체 코드를 보여줄 것

# Guidelines

## Project Structure & Module Organization
- `LearningKanji/` — app source
  - `Application/` (entry, `LearningKanjiApp`, `DIContainer`)
  - `Domain/` (Entities, UseCase Services, Repository protocols)
  - `Data/` (Storage, Repository implementations, SwiftData DTO mapping)
  - `Presentation/` (SwiftUI views/view-models, Router)
  - `Resources/` (Assets, fonts, `japanese_kanji_2136.json`, localization)
- Tests: `LearningKanjiTests/`, `LearningKanjiUITests/`

## Build, Test, and Development Commands
- Open in Xcode: `open LearningKanji.xcodeproj`
- Build (Simulator): `xcodebuild -scheme LearningKanji -destination 'platform=iOS Simulator,name=iPhone 15' build`
- Unit tests: `xcodebuild test -scheme LearningKanji -destination 'platform=iOS Simulator,name=iPhone 15'`
- Run on device: select a Team and enable capabilities (iCloud, Sign in with Apple, In‑App Purchases) in the Xcode target.

## Coding Style & Naming Conventions
- Swift 5+, 4‑space indentation, one type per file.
- Names: `PascalCase` for types/modules; `camelCase` for vars/functions.
- Suffixes: `...Service` (UseCase), `...Repository` (protocol/impl), `...DTO` (SwiftData model), `...View`/`ViewModel` (UI).
- Keep DI via `DIContainer`; do not instantiate repositories directly in views.

## Testing Guidelines
- Framework: XCTest (unit/UI). Name tests `FeatureNameTests.swift` and mirror source layout.
- Place UI tests in `LearningKanjiUITests` and prefer accessibility identifiers.
- Run fast, deterministic tests; mock repositories via existing `Mock*` types.

## Commit & Pull Request Guidelines
- Prefer Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`.
- Message style: present tense, concise. Example: `feat: add SwiftData model for Kanchu projects`.
- PRs: clear description, linked issues, screenshots for UI, and notes on testing/impact. Keep diffs focused.

## Architecture Overview
- Clean layering (Presentation/Domain/Data). Use Cases mediate features (e.g., Today’s Kanji, Search, Kanchu Quiz).
- Persistence: SQLite (bookmarks), SwiftData (Kanchu projects), CloudKit sync (optional).
