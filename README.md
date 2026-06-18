# EFG Converter

A polished currency converter app built for the EFG Holding Flutter Engineer Assessment.
Live exchange rates, full conversion history, offline support, and a dark/light design system.

---

## Getting Started

### Prerequisites

* Flutter Stable SDK
* Dart SDK 3.9.2 or later

### Run the Project

```bash
git clone https://github.com/Omar25876/EFG-Converter.git
cd EFG-Converter
flutter pub get
flutter run
```

### API

The application uses the Frankfurter API for live exchange rates:

https://www.frankfurter.app

No API key or additional configuration is required.

**State management:** Cubit (flutter_bloc). Each screen owns its Cubit; cubits are
registered as factories in GetIt so they are isolated and disposable.

**Repository pattern:** `IUnitOfWork`-style — each feature has an abstract repository
interface in the domain layer, implemented in the data layer. Use-cases wrap repository
calls and are the only entry point from the presentation layer.

**Offline strategy:**
1. On success — cache rates and currency list to Hive.
2. On network failure — serve last cached rates; show an `OfflineBanner`.
3. No cache and no connection — surface an error state with retry.

---

## Design System

| Token | Value |
|---|---|
| Primary | Rose Magenta `#E0245E` |
| Primary Light | Soft Pink `#FF6B9D` |
| Accent | Amber Gold `#F59E0B` |
| Background (dark) | Midnight `#0D0D14` |
| Surface (dark) | Deep Navy `#13121F` |
| Card (dark) | `#1C1B2E` |
| Font | Cairo (Arabic-friendly, RTL-compatible) |

Colors are defined once in `colors.dart` and resolved through `AppColors` /
`context.colors` semantic tokens, so every widget automatically adapts to dark or
light mode without branching.

Gradients used for hero elements:
- **heroGradient** — Rose → Purple (buttons, FAB, swap)
- **accentGradient** — Gold → Amber (result card)
- **cardGradient** — Dark surface gradient

---

## Features

- Live exchange rates from `frankfurter.app/latest`
- Currency list from `frankfurter.app/currencies`
- Swap currencies with animation
- Input validation
- Conversion history persisted in Hive across app restarts
- Delete individual history entries
- Offline fallback using last cached rates
- Dark / Light mode via design system theme toggle
- Shimmer loading states and error retry
- Animated bottom navigation with floating FAB
- Localisation-ready (easy_localization)

---

## AI Usage

**Tools Used**

* Claude

**What I Used Them For**

* Brainstorming UI/UX ideas and refining the visual design.
* Generating and iterating on animations used in the splash screen and navigation components.
* Assisting with theming decisions, color palette exploration, gradients, and visual consistency.
* Generating boilerplate code for some models and repetitive structures.
* Reviewing code and suggesting improvements for maintainability and readability.
* Assisting in writing and formatting this README.

**What Was Implemented Manually**

* Application architecture (Clean Architecture layers and project structure).
* Dependency Injection setup and service registration.
* API integration using Dio.
* Data source and repository implementations.
* State management using Cubit/BLoC.
* Localization setup and language handling.
* Local storage integration and business logic.
* Feature implementation, testing, debugging, and final integration.

**How I Verified the Output**

* Reviewed all AI-generated code before integrating it into the project.
* Manually tested navigation flows, currency conversion scenarios, and history persistence.
* Verified API responses and model mapping against the Frankfurter API documentation.
* Ran the application from a clean setup and validated that it builds and runs successfully.
 