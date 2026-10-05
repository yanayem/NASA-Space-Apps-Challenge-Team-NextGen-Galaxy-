# NASA Space App 🚀

A full-stack mobile application built with **Flutter**, **Django REST Framework**, and **Firebase**.

---

## 🏗️ Architecture Overview

```
+-------------------------------------------------------+
|                 Flutter Mobile App                    |
|  - UI & State Management (BLoC / Provider / Riverpod) |
|  - Firebase SDK (Auth, FCM, Storage)                 |
|  - HTTP Client (Dio / http)                           |
+--------------------------+----------------------------+
                           |
            +--------------+--------------+
            |                             |
            v                             v
+-----------------------+     +-----------------------+
|  Firebase Services    |     | Django REST Backend   |
|  - Firebase Auth      |     | - NASA API Client     |
|  - FCM Notifications  |     | - Business Logic      |
|  - Cloud Storage      |     | - Custom Database     |
+-----------+-----------+     +-----------+-----------+
            |                             |
            +--------------+--------------+
                           |
                           v
              [ Firebase Admin SDK Verification ]
```

---

## 📂 Project Structure

```
Nasa Space App/
├── mobile/                  # Flutter mobile application
├── backend/                 # Django REST Framework backend
└── README.md                # Documentation & setup guide
```

---

## 🚀 Quick Setup Instructions

### 1. Backend Setup (Django REST Framework)

```bash
cd backend
python -m venv venv
# On Windows PowerShell:
.\venv\Scripts\Activate.ps1

pip install django djangorestframework django-cors-headers firebase-admin requests python-dotenv

# Run initial migrations & start server
python manage.py migrate
python manage.py runserver
```

### 2. Mobile Setup (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```

### 3. Firebase Configuration

- **Flutter**: Configure using `flutterfire configure` CLI to generate `firebase_options.dart`.
- **Django**: Place your Firebase Service Account JSON (`serviceAccountKey.json`) in `backend/` and initialize `firebase_admin` in Django settings.

---

## 🛰️ NASA APIs Integration

The Django backend serves as a proxy/aggregator for official NASA APIs (APOD, NeoWs, Mars Rover Photos, EPIC, etc.):
- Base NASA API URL: `https://api.nasa.gov/`
- API keys managed securely via Django `.env` file.
