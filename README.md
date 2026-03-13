# Elaros-App
ELAROS-MOBILE-APPLICATION
https://www.figma.com/design/RLXFKz5XpCqOszv0DccnJs/Untitled?node-id=0-1&t=ZZKUOqnthqXHwHb0-1

---

## Authentication System

### Login & Signup
- Login screen with email/password validation and error handling
- Multi-step signup flow: Account Details -> Personal Info -> Health Baseline
- Password hashing with SHA-256 (via `crypto` package)
- Session persistence using `shared_preferences` (stays logged in across app restarts)
- Route protection: app redirects to login screen if not authenticated
- Logout button on profile page

### Test Accounts
| Email | Password | User |
|---|---|---|
| sarah@elaros.com | password123 | Sarah Mitchell (47, Long Covid) |
| james@elaros.com | password123 | James Cooper (43, ME/CFS) |

---

## Database (main.db) - 16 Tables, 7500+ Rows

| Table | Rows | Description |
|---|---|---|
| **Auth** | 2 | Email/password authentication (SHA-256 hashed) |
| **UserProfile** | 2 | Name, age, condition, resting HR, max HR |
| **HealthBaseline** | 2 | Baseline health data (name, age, condition, RHR, MHR) |
| **HeartRate** | 2,688 | HR readings every 15 min with zone classification |
| **HRV** | 28 | Daily heart rate variability scores (25-65 range) |
| **StepCount** | 672 | Hourly step counts with realistic day/night patterns |
| **ActivityZone** | 10 | 5 custom HR zones per user (Recovery -> Overexertion) |
| **FitnessGoal** | 6 | Personalised fitness goals (steps, resting HR, sleep) |
| **DailySnapshot** | 28 | Daily summaries (avg/resting/peak HR, steps, HRV, exertion flags) |
| **Insight** | 33 | Auto-generated insights: exertion warnings, low HRV, activity alerts |
| **CaloriesConsumption** | 672 | Hourly calorie data |
| **SleepLog** | 2,688 | Every 5 min from 10pm-6am (asleep/restless/awake) |
| **Intensity** | 672 | Hourly activity intensity levels |
| **SleepState** | 3 | Lookup: asleep, restless, awake |
| **IntensityState** | 4 | Lookup: sedentary, light, moderate, vigorous |
| **AppSettings** | 2 | Theme (light/dark), colour-blind mode |

Data spans **Feb 27 - Mar 12, 2026** with realistic patterns (lower HR/steps at night, higher during day, occasional exertion warnings).

### Read-Only Dataset (health_lite.db) - 7 Tables
| Table | Rows |
|---|---|
| HeartRate | 38,714 |
| StepCount | 9,600 |
| CaloriesConsumption | 9,600 |
| SleepLogs | 25,035 |
| Intensities | 9,600 |
| SleepStates | 3 |
| IntensityStates | 4 |

---

## Profile Page (Merged from Mysha_New_branch)
- Dynamic data loaded from DB (user profile, goals, personalised activity zones)
- Editable fields: name, age, condition, resting HR, max HR
- Save/load profile to database
- Displays personalised HR zones with actual bpm ranges per user
- Fitness goals with progress tracking
- Zone calculation explanation
- Data & Privacy section
- About Elaros section

---

## iOS Build Configuration
- **Podfile** created with platform iOS 13.0
- CocoaPods configured for all Flutter plugins (sqflite, shared_preferences, path_provider, crypto)
- Deployment target: iOS 13.0 across all build configurations (Debug, Release, Profile)
- Bundle ID: `com.example.elarosMobileApp`
- iOS generated files added to `.gitignore` (Pods/, Podfile.lock, GeneratedPluginRegistrant, etc.)

---

## New Files Created

### Models (`lib/data/local/model/`)
- `auth_user.dart` - Auth table model
- `user_profile.dart` - User profile with baseline health details
- `health_baseline.dart` - HealthBaseline table model (RHR, MHR)
- `hrv.dart` - Heart rate variability model
- `step_count.dart` - Step count model
- `activity_zone.dart` - 5-zone HR model per user
- `fitness_goal.dart` - Personalised fitness goals
- `daily_snapshot.dart` - Daily health summary
- `insight.dart` - Auto-generated health insights
- `sleep_log.dart` - Sleep tracking model
- `app_settings.dart` - Theme and accessibility settings

### Services (`lib/data/local/services/`)
- `auth_service.dart` - Login, signup, logout, session management
- `database_helper.dart` - Full CRUD for all 16 tables

### UI (`lib/ui/auth/`)
- `login_screen.dart` - Login page with validation
- `signup_screen.dart` - 3-step signup (Account, Profile, Health Baseline)

### Repository (`lib/data/local/repository/`)
- `health_baseline_repository.dart` - HealthBaseline CRUD wrapper

### iOS
- `ios/Podfile` - CocoaPods configuration

---

## How to Run

### Android
```bash
flutter pub get
flutter run
# OR build APK:
flutter build apk --debug
```
The APK will be at `build/app/outputs/flutter-apk/app-debug.apk`

### Android Developer Mode Setup
1. Go to **Settings -> About Phone -> tap "Build Number" 7 times**
2. Go back to **Settings -> Developer Options -> enable "USB Debugging"**
3. Connect phone via USB
4. Run `flutter devices` to verify detection
5. Run `flutter run`

### iOS (requires Mac with Xcode)
```bash
flutter pub get
cd ios && pod install && cd ..
flutter run
# OR for release:
flutter build ios
```

---

## Dependencies
```yaml
provider: ^6.1.5+1
navbar_router: ^0.7.7
path: ^1.9.1
path_provider: ^2.1.5
sqflite: ^2.4.2
cristalyse: ^1.17.3
sqflite_common_ffi_web: ^1.1.1
crypto: ^3.0.6
shared_preferences: ^2.3.4
```
