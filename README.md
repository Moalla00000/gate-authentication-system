# Gate Authentication System

A comprehensive, decoupled authentication system featuring a secure Node.js/Express backend and a modern Flutter mobile application. This project uses Firebase Authentication for identity management and PostgreSQL for data persistence.

## 🚀 Project Overview

The project is split into two main components:

- **Backend**: A RESTful API built with Node.js, Express, PostgreSQL, and Redis. It handles user synchronization, profile management, avatar uploads to Cloudinary, and robust security through Arcjet.
- **Frontend**: A cross-platform mobile application built with Flutter. It utilizes Riverpod for state management, GoRouter for declarative routing, and follows a feature-first architecture.

---

## 🏗️ Architecture & Technologies

### Backend

- **Framework**: Express.js
- **Database**: PostgreSQL (via `pg`)
- **Caching/Rate Limiting**: Redis (Upstash) & Arcjet
- **Authentication**: Firebase Admin SDK
- **Storage**: Cloudinary (user avatars)
- **Documentation**: Swagger UI

### Frontend

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Routing**: GoRouter
- **Authentication**: Firebase Authentication & Google Sign-In
- **Networking**: Dio

---

## ⚙️ Prerequisites

Before you begin, ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v18 or higher recommended)
- [pnpm](https://pnpm.io/) (for backend package management)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- PostgreSQL (running locally or remotely)
- Firebase Project Setup (with Authentication enabled)
- Cloudinary Account
- Upstash Redis Database
- Arcjet Account

---

## 🛠️ Installation & Setup

### 1. Backend Setup

Navigate to the backend directory and install dependencies:

```bash
cd backend
pnpm install
```

Configure environment variables:

```bash
cp .env.example .env
```

Fill out the variables in `.env`:

- **App**: `NODE_ENV`, `PORT` (default 5000), `DATABASE_URL` (your PostgreSQL connection string).
- **CORS**: `CLIENT_URL`.
- **Arcjet**: `ARCJET_KEY`, `ARCJET_ENV`.
- **Cloudinary**: `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`.
- **Firebase**: `FIREBASE_SERVICE_ACCOUNT` (path to your `serviceAccountKey.json` file or stringified JSON).
- **Redis**: `UPSTASH_REDIS_REST_URL`, `UPSTASH_REDIS_REST_TOKEN`.

Add your Firebase Admin SDK key:
Ensure that your `serviceAccountKey.json` from Firebase is accessible to the backend (or placed in the `backend/` directory if referencing via file path).

### 2. Frontend Setup

Navigate to the frontend directory and install dependencies:

```bash
cd frontend
flutter pub get
```

Configure environment variables:

```bash
cp .env.example .env
```

Update `.env` with:

- `API_BASE_URL`: The URL of your local or remote backend API (e.g., `http://10.0.2.2:5000/api` for Android emulator or `http://localhost:5000/api` for iOS simulator).

Firebase configuration:
Make sure you generate and include the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) in their respective platform directories within `frontend/` using the FlutterFire CLI.

---

## 🏃‍♂️ Running the Project

### Start the Backend

The backend initializes the PostgreSQL tables automatically on startup via `initializeDatabase()`.

```bash
cd backend
pnpm run dev
```

The API will be available at `http://localhost:5000`.
You can view the Swagger API documentation at `http://localhost:5000/api-docs`.

### Start the Frontend

```bash
cd frontend
flutter run
```

Select your desired emulator or physical device when prompted.

---

## 🧪 Testing & Debugging

### Backend Debugging

- We use **morgan** and **winston** for logging. Ensure `NODE_ENV=development` in your `.env` to see detailed endpoint requests in the terminal logs.
- Test endpoints directly using the built-in Sandbox via Swagger UI at `/api-docs`.

### Frontend Debugging

- Riverpod state changes, navigation events, and Dio network requests can be observed via the terminal console during development runs.
- Use `flutter logs` or the debug console in your IDE.

---

## 🚀 Deployment Notes

### Backend

- Ensure `NODE_ENV` is set to `production`.
- The entry point for production is `src/server.js` (you can run `pnpm start`).
- Standard deployment platforms include platforms like Render, Railway, AWS EC2, or Heroku.
- Remember to configure all Secrets/Environment Variables in your hosting provider's dashboard.

### Frontend

- Build the APK/App Bundle for Android:
  ```bash
  flutter build apk --release
  flutter build appbundle --release
  ```
- Build the IPA for iOS:
  ```bash
  flutter build ipa --release
  ```
- Make sure that OAuth configuration (SHA-1/SHA-256 fingerprint hashes for Android Google Sign-In) is correctly updated in the Firebase Console and Google Cloud Console for the release keystores.
