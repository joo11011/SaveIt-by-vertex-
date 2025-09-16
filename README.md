# SaveIt
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/joo11011/SaveIt-by-vertex-)

SaveIt is a comprehensive mobile application built with Flutter, designed to empower users with smart money management tools. It provides a simple and engaging way to track income, expenses, and installments. The app also features an integrated AI-powered chatbot, "SaveIt Chat," to offer financial advice and answer user queries, creating an interactive and supportive financial management experience.

## Key Features

- **Secure Authentication:** Sign in with Email/Password, Google, or as a Guest. Includes features for password reset and account deletion.
- **Comprehensive Dashboard:** Get an at-a-glance view of your remaining balance, total income, and expenses with a dynamic circular progress indicator.
- **Income Management:** Easily add, view, and manage all your sources of income.
- **Expense Tracking:** Record your expenses with customizable categories to better understand your spending habits.
- **Installment Management:** Keep track of upcoming and paid installments with due date reminders, ensuring you never miss a payment.
- **AI-Powered Financial Assistant:** Chat with "SaveIt Chat" for personalized financial advice and tips, powered by Google's Generative AI.
- **User Profile:** Customize your profile with a picture and manage personal information.
- **App Settings:** Switch between Light/Dark modes and change the app language (supports English and Arabic).
- **Data Persistence:** All financial data is securely stored and synced in real-time using Firebase Firestore.

## Technology Stack

- **Framework:** Flutter
- **Backend:** Firebase (Authentication, Firestore, Storage)
- **State Management:** GetX & Provider
- **AI:** Google Generative AI (Gemini)
- **Localization:** GetX Localization

## Project Structure

The project follows a clean architecture to separate concerns:

-   `lib/controller`: Contains the business logic and state management using GetX controllers (`LoginController`, `SettingsController`, etc.).
-   `lib/core`: Holds core components and helper classes like `ValidationHelper`, as well as `Provider`-based data providers (`UserProvider`, `CurrencyProvider`).
-   `lib/model`: Defines the data models for the application (`UserModel`, `ExpenseModel`, `InstallmentModel`).
-   `lib/services`: Manages communication with external services, primarily Firebase (`AuthService`, `ExpenseService`, `FirebaseService`).
-   `lib/view`: Contains all the UI screens and widgets, organized by feature.

## Setup and Installation

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   Flutter SDK installed. You can find instructions [here](https://flutter.dev/docs/get-started/install).

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/joo11011/saveit-by-vertex-.git
    ```

2.  **Navigate to the project directory:**
    ```sh
    cd saveit-by-vertex-
    ```

3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

4.  **Firebase Setup:**
    -   Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    -   Add an Android and/or iOS app to your Firebase project.
    -   Follow the Firebase setup instructions to download `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS).
    -   Place `google-services.json` in the `android/app/` directory.
    -   Place `GoogleService-Info.plist` in the `ios/Runner/` directory via Xcode.
    -   In your Firebase project console, enable the following services:
        -   **Authentication**: Enable Email/Password and Google sign-in methods.
        -   **Firestore Database**: Create a new database.
        -   **Storage**: Create a storage bucket.

5.  **Run the application:**
    ```sh
    flutter run
