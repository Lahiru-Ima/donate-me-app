# Donate Me App

A Flutter-based donation management application built for ICBT 2025 university assignment. This app allows users to make and track donations, manage urgent requests, and facilitate charitable giving.

## Features

- 📱 Cross-platform Flutter application (iOS, Android, Web)
- 🔐 User authentication and profile management
- 💰 Donation tracking and management
- 🚨 Urgent request handling
- 📊 Dashboard with donation statistics
- 🎨 Modern UI with custom widgets

## Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Supabase
- **State Management**: Provider
- **Navigation**: Go Router
- **UI Components**: Custom widgets with Material Design
- **Image Handling**: Image Picker
- **Local Storage**: Shared Preferences

## Getting Started

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / VS Code
- Supabase account (for backend services)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/donate-me-app.git
cd donate-me-app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Set up environment variables:
   - Create a `.env` file in the root directory
   - Add your Supabase credentials:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. Run the app:

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── src/
│   ├── common_widgets/      # Reusable UI components
│   ├── constants/           # App constants and configurations
│   ├── features/           # Feature-based modules
│   ├── models/             # Data models
│   ├── providers/          # State management providers
│   ├── router/             # Navigation routing
│   └── services/           # API and backend services
```

## Contributing

This project is part of a university assignment for ICBT 2025. Contributions are welcome for educational purposes.

## License

This project is created for educational purposes as part of ICBT 2025 curriculum.

## Contact

For any questions or support, please contact the development team.
