# Weather Todo

A Flutter-based mobile application that combines weather information and todo management in a simple, user-friendly interface.

## Overview

This is a basic app with two main tabs:
- **Todo Tab**: Manage your daily tasks and to-do items
- **Weather Tab**: View current weather conditions and forecasts

## Features

- **Authentication**: Simple login system
- **Todo Management**: Create, edit, delete, and mark todos as complete
- **Weather Information**: Real-time weather data and forecasts
- **Responsive UI**: Clean and intuitive user interface
- **Offline Support**: Local storage for todos

## Login Credentials

- **Username**: `test`
- **Password**: `1234`

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture pattern:
- In some screens, ViewModel is replaced with **Provider** pattern
- **Riverpod** is used for state management throughout the app
- Clean separation of concerns between UI, business logic, and data layers

## Technology Stack

- **Flutter & Dart**: Mobile app framework
- **Riverpod**: State management solution
- **Dio**: HTTP client for web API requests
- **Hive**: Local database for offline storage
- **Material Design**: UI components and design system

## Testing

The app includes comprehensive testing:

### Integration Tests
- **Login Page Tests**: End-to-end testing of the authentication flow

### Unit Tests
- **HiveStore Tests**: Testing local storage operations
- **Todo Provider Tests**: Testing todo state management and business logic

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd weather_todo
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running Tests

#### Unit Tests
```bash
flutter test test/unit/
```

#### Integration Tests
```bash
flutter test integration_test/features/login/login_test.dart
```

## Project Structure

```
lib/
├── config/          # App configuration
├── data/            # Data layer (repositories, services)
├── domain/          # Domain layer (models, entities)
├── routing/         # App routing configuration
├── ui/              # Presentation layer
│   ├── auth/        # Authentication screens
│   ├── home/        # Home screen with tabs
│   ├── todo/        # Todo management
│   └── weather/     # Weather information
└── utils/           # Utility functions

test/
├── unit/            # Unit tests
└── integration_test/ # Integration tests
```

## API Integration

- Weather data is fetched from external weather APIs using Dio
- Todo data is stored locally using Hive database
- Proper error handling and offline support implemented

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
