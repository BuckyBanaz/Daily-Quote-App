# Daily Quotes App

A beautiful, premium daily quote application built with Flutter, driven by AI tools.

## Features
- **Daily Inspiration**: Fetches random quotes from ZenQuotes API.
- **Favorites**: Save your favorite quotes to a local list (persisted).
- **Share**: Share quotes directly to social media or other apps.
- **Dark Mode**: Premium dark aesthetic with smooth gradients.

## Tech Stack
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: GetX
- **Networking**: Dio
- **Local Storage**: SharedPreferences
- **Routing**: GetX Navigation

## Setup Instructions

1.  **Prerequisites**: Ensure you have Flutter SDK installed (`flutter doctor`).
2.  **Clone the repo**:
    ```bash
    git clone <repo-url>
    cd daily_quotes
    ```
3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run the App**:
    ```bash
    flutter run
    ```

## AI Coding Approach & Workflow
This project was built using an AI-first approach, leveraging an advanced coding agent.

### 1. Planning & Architecture
- **Prompt**: "Build a Daily Quote App using Flutter with GetX for state management, Dio for networking, and SharedPreferences for local storage."
- **Reasoning**: The AI selected GetX for its simplicity and boilerplate reduction, making the code clean and readable as per requirements.

### 2. Implementation
- Generated the core data models (`Quote`).
- Implemented robust services (`ApiService`, `StorageService`) with error handling.
- Created reactive controllers (`HomeController`, `FavoritesController`) to separate logic from UI.
- Designed the UI with a focus on aesthetics (Gradients, Google Fonts) to meet the "premium design" criteria.

### 3. Iteration & Debugging
- The AI automatically handled dependency management (`flutter pub add ...`).
- Code was verified using `flutter analyze` to ensure no linting errors.

## Design
The design focuses on a modern, minimal aesthetic:
- **Typography**: Uses 'Cinzel' for quotes (classic, elegant) and 'Outfit' for UI elements (clean, modern).
- **Color Palette**: Dark charcoal backgrounds (`#1A1A1A`) mixed with subtle gradients to reduce eye strain and look professional.
- **UX**: Simple gestures (tap to refresh, heart to favorite) and fluid transitions.

## Screenshots
*(Insert screenshots of Home and Favorites screen here)*
