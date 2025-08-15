
# Loans Tracker

A modern Flutter application for managing personal loans with a clean, intuitive interface.

## Features

### 📱 **Core Functionality**
- **Loan Management**: Add, edit, and track personal loans
- **Smart Status Tracking**: Automatic calculation of days left/overdue
- **CSV Export**: Export all loan data to CSV files for backup or analysis
- **Full-page Editing**: Clean, distraction-free loan editing experience

### 🎨 **Modern UI/UX**
- **Material 3 Design**: Clean, modern interface
- **Dark/Light Themes**: Automatic system theme support
- **Custom Accent Colors**: Choose from 5 beautiful accent colors
- **Swipeable Navigation**: Smooth tab navigation between All/Active/Paid loans
- **Responsive Layout**: Optimized for all screen sizes

### 📊 **Dashboard Analytics**
- **Overview Cards**: Quick stats on total loans, active loans, and amounts
- **Due Soon Alerts**: Prominent display of upcoming due dates
- **Visual Indicators**: Clear status indicators for loan progress

### ⚡ **Performance**
- **Animation-free**: Optimized for smooth performance
- **Clean Architecture**: Well-structured codebase
- **No Unnecessary Effects**: Focus on functionality over visual clutter

## Screenshots

*Add screenshots of your app here*

## Installation

### Prerequisites
- Flutter SDK (>=3.8.1)
- Android Studio / Xcode for mobile development
- Git

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/loans-tracker.git
   cd loans-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── main_tabs.dart         # Main tab navigation
├── models/                # Data models
│   ├── person.dart
│   └── contract.dart
├── pages/                 # App screens
│   ├── home_page.dart
│   ├── dashboard_page.dart
│   ├── loan_edit_page_new.dart
│   ├── loan_details_page.dart
│   ├── settings_page.dart
│   └── contract_page.dart
├── theme/                 # Theme configuration
│   └── theme_controller.dart
├── utils/                 # Utilities
│   ├── loan_provider.dart
│   ├── csv_exporter.dart
│   ├── interest_calculator.dart
│   └── notification_service.dart
└── widgets/               # Reusable widgets
    └── loan_card_compact.dart
```

## Configuration

### Package Information
- **Package Name**: `com.naonga.commandLine`
- **App Name**: Loans Tracker
- **Version**: 1.0.0+1

### Supported Platforms
- ✅ Android
-  iOS
-  macOS
-  Web
-  Windows
-  Linux

## Dependencies

### Core Dependencies
- `flutter`: Framework
- `provider`: State management
- `intl`: Internationalization
- `shared_preferences`: Local storage
- `uuid`: Unique ID generation

### Export & Sharing
- `csv`: CSV file generation
- `share_plus`: File sharing
- `path_provider`: File system access

### UI & Icons
- `flutter_launcher_icons`: Custom app icons
- Material Icons (built-in)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Developer

**Naonga Gondwe**  
*CommandLine*

## Changelog

### v1.0.0 (Initial Release)
- ✅ Complete loan management system
- ✅ CSV export functionality
- ✅ Modern Material 3 UI
- ✅ Dark/Light theme support
- ✅ Custom app icon
- ✅ Multi-platform support
- ✅ Clean, animation-free interface

---

