# Daily Quote App v2 📱✨

[![Documentation Website](https://img.shields.io/badge/View_Documentation_Website-26A69A?style=for-the-badge&logo=googlechrome&logoColor=white)](https://buckybanaz.github.io/Daily-Quote-App/)

A premium, production-ready Flutter and Laravel application built 90% via AI. It delivers daily inspiration with a beautiful design, robust backend, and intelligent notification system.

## 🚀 Features

*   **User Authentication**: Secure Login/Signup with Laravel Sanctum, including Email Verification.
*   **Daily Inspiration**: Personalized quotes based on your selected categories and preferred time.
*   **Categories**: Browse quotes by various categories (Motivation, Love, Success, etc.).
*   **Favorites & Likes**: Save your most loved quotes and track popular ones.
*   **Smart Notifications**: Custom-scheduled daily reminders with support for Android 12+ exact alarms.
*   **Premium UI**: Glassmorphism, smooth staggered animations, and refined typography.
*   **Global Search**: Instant search for quotes by content or author.
*   **Beautiful Sharing**: Animated share sheet for social media and text sharing.

## 🏗️ Technical Architecture

### Frontend (Flutter Stack)
- **Framework**: Flutter (Android & iOS)
- **State Management**: GetX
- **Networking**: Dio
- **Storage**: Shared Preferences
- **Theming**: Custom Theme Engine (Light/Dark Mode Support)
- **Notifications**: Flutter Local Notifications (with Android 12 exact alarm fixes)

### Backend (Laravel Stack)
- **Framework**: Laravel 11
- **Database**: MariaDB
- **Authentication**: Laravel Sanctum
- **API Documentation**: Swagger
- **Pattern**: Repository Pattern with clean MVC architecture

## 🤖 The AI development Journey (Built 90% by AI)

This project showcases the power of Agentic AI. Developed in just **14 hours**, with 90% of the codebase and design generated through:
- **ChatGPT**: Ideation, Architectural planning, and advanced Prompt Engineering.
- **Google Stitch**: Visual design generation and cohesive UI/UX mapping.
- **Antigravity (Google)**: Complete development lifecycle, implementation, and complex bug fixing.

## 📸 App Showcase

<p align="center">
  <img src="docs/ss.gif" width="250" alt="App Demo">
</p>

## 🛠️ Setup Instructions

### 1. Backend Setup (Laravel)
```bash
cd backend
composer install
cp .env.example .env
# Configure DB_DATABASE, DB_USERNAME, DB_PASSWORD in .env
php artisan key:generate
php artisan migrate --seed
php artisan serve --host=0.0.0.0 --port=8000
```

### 2. Frontend Setup (Flutter)
```bash
cd daily_quotes
flutter pub get
# Update lib/constant/api_endpoints.dart with your server IP
flutter run
```

The full design workflow, prompt analysis, and technical deep-dives are available in the professional documentation hosted here:
[**Daily Quote App v2 Documentation**](https://buckybanaz.github.io/Daily-Quote-App/)

## 👨‍💻 About the Developer
**Parikshit Verma** — Mobile Application Developer (2 Years Experience)
- **Primary Stack**: Flutter & Dart
- **Portfolio**: [parikshit.techycodex.com](https://parikshit.techycodex.com)
- **Philosophy**: AI-Native Engineer focusing on building production-level applications efficiently by leveraging AI tools throughout the development lifecycle.

I treat AI as a collaborator to speed up development, translate requirements into functional products, and maintain clean, maintainable code.

---
*Generated & Directed by Google Antigravity Agent*
