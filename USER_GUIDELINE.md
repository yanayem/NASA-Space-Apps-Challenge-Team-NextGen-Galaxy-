# SpaceRisk — End-to-End User & Operational Guide 🌌

Welcome to **SpaceRisk**, an Earth-observation powered location intelligence platform created by **Team NextGen Galaxy** for the NASA Space Apps Challenge.

> **Motto:** *"Before You Build. Know the Risk."*

---

## 📋 Table of Contents
1. [Project Overview & Architecture](#-project-overview--architecture)
2. [Prerequisites & Requirements](#-prerequisites--requirements)
3. [Running the Backend (Django REST Framework)](#-running-the-backend-django-rest-framework)
4. [Running the Frontend (Flutter Mobile / Web / Desktop)](#-running-the-frontend-flutter-mobile--web--desktop)
5. [Connecting Frontend to Backend](#-connecting-frontend-to-backend)
6. [Feature Walkthrough & How to Use](#-feature-walkthrough--how-to-use)
   - [Dashboard & Quick Health](#1-dashboard--quick-health)
   - [Single-Site Risk Evaluation Engine](#2-single-site-risk-evaluation-engine)
   - [Multi-Site Comparison (Killer Feature)](#3-multi-site-comparison-killer-feature)
   - [Environmental Indicators & Historical Trend Charts](#4-environmental-indicators--historical-trend-charts)
   - [B2B Executive Risk Reports](#5-b2b-executive-risk-reports)
   - [NASA Astronomy Picture of the Day (APOD)](#6-nasa-astronomy-picture-of-the-day-apod)
   - [Settings & Customization](#7-settings--customization)
7. [Running Automated Tests](#-running-automated-tests)

---

## 🌟 Project Overview & Architecture

SpaceRisk transforms raw multi-year Earth-observation datasets (Harmonized Landsat Sentinel-2, MODIS, VIIRS, Global Surface Water) into practical risk scores and engineering mitigations for major infrastructure investments (warehouses, factories, solar farms, telecom towers, data centers).

```
┌────────────────────────────────────────────────────────┐
│                   Flutter Frontend                     │
│  (Mobile Android/iOS, Web Chrome/Edge, Windows Desktop)│
└───────────────────────────┬────────────────────────────┘
                            │ REST API (JSON)
                            ▼
┌────────────────────────────────────────────────────────┐
│                  Django REST Backend                   │
│   • Multi-Criteria Decision Analysis (MCDA) Scoring    │
│   • Dynamic Project-Weight Matrix Engine               │
│   • NASA API Gateway & HLS / MODIS Indicator Pipeline  │
└────────────────────────────────────────────────────────┘
```

---

## ⚙️ Prerequisites & Requirements

- **Python**: 3.10+ (Tested on Python 3.11)
- **Flutter SDK**: 3.22+ (Tested on Flutter 3.44.7 / Dart 3.12.2)
- **Web Browser or Simulator**: Chrome, Edge, Windows Desktop or Android Emulator

---

## 🚀 Running the Backend (Django REST Framework)

1. Open a terminal in the project root:
   ```bash
   cd backend
   ```
2. (Optional) Activate your virtual environment if one is created:
   ```bash
   # Windows PowerShell:
   .\venv\Scripts\Activate.ps1
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run database migrations:
   ```bash
   python manage.py migrate
   ```
5. Start the development server:
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```
6. The backend is now live:
   - **Base URL**: `http://127.0.0.1:8000/api/`
   - **Health Check**: `http://127.0.0.1:8000/api/health/`
   - **Swagger / OpenAPI Documentation**: `http://127.0.0.1:8000/api/docs/`

---

## 📱 Running the Frontend (Flutter)

1. Open another terminal in the project root:
   ```bash
   cd mobile
   ```
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   - **Run in Chrome (Web)**:
     ```bash
     flutter run -d chrome
     ```
   - **Run on Windows Desktop**:
     ```bash
     flutter run -d windows
     ```
   - **Run on Android Emulator**:
     ```bash
     flutter run -d <emulator-id>
     ```

---

## 🔌 Connecting Frontend to Backend

SpaceRisk is designed with **dual-mode intelligence**:
1. **Live Backend Mode**: When connected to `http://127.0.0.1:8000` (or your deployed cloud backend), it fetches live computed scores from the Django API.
2. **Offline Seed / Demo Mode**: If the backend is unreachable or offline, the app automatically fails over to high-fidelity simulated seed data so the user experience is never interrupted.

To configure or test the backend URL directly in the app:
1. Open the app and navigate to **Settings** (gear icon in the bottom bar or drawer).
2. Under **Backend Configuration**, inspect the API Base URL.
3. Tap **Test Connection** to immediately verify live handshake status with the Django engine.

---

## 📖 Feature Walkthrough & How to Use

### 1. Dashboard & Quick Health
- Provides high-level operational status, active project statistics, and quick navigation to all modules.
- Displays NASA Earth-observatory active sensors and quick summary cards.

### 2. Single-Site Risk Evaluation Engine
- **Where**: Tap **Site Risk** on the navigation bar.
- **How to use**:
  1. Enter a **Site Name** (e.g., *Gazipur Logistics Hub*).
  2. Input **Latitude** and **Longitude** (or select a pre-populated preset like *Dhaka*, *Chattogram*, *Khulna*, or *Sylhet*).
  3. Select **Project Type** (*Warehouse*, *Factory*, *Solar Farm*, *Data Center*, *Telecom Tower*).
  4. Tap **Run Risk Analysis**.
- **Results**:
  - **SpaceRisk Score (0–100)**: Displayed on a visual gauge with color-coded risk levels (*Low*, *Moderate*, *High*, *Extreme*).
  - **Sub-Score Radar / Breakdown**: Specific vulnerability indices for flood risk, heat risk, environmental change, water fluctuation, and stability.
  - **Actionable Mitigations**: Engineering recommendations tailored to the site (e.g., foundation elevation levels, cool roof coating, drainage retention).

### 3. Multi-Site Comparison (Killer Feature)
- **Where**: Tap **Comparison** on the navigation bar.
- **How to use**:
  1. Add 2 to 5 candidate sites with their geographic coordinates.
  2. Pick the intended infrastructure project type.
  3. Tap **Compare Sites**.
- **Results**:
  - Automatically calculates and ranks each candidate site side-by-side.
  - Visualizes relative flood risk, heat risk, water change, and stability scores.
  - Generates an executive decision: highlights the **Best Choice Candidate** with lowest overall environmental volatility.

### 4. Environmental Indicators & Historical Trend Charts
- **Where**: Tap **Indicators** on the navigation bar.
- **How to use**:
  1. Select a location and multi-year time range (e.g., 2018 to 2024).
  2. Tap **Analyze Trends**.
- **Indicators Displayed**:
  - **NDVI (Vegetation Index)**: Multi-year canopy and vegetation dynamics.
  - **NDWI (Surface Water Index)**: Water presence and flood risk expansion.
  - **NDBI (Built-up Index)**: Rate of urbanization and ground imperviousness.
  - **LST (Land Surface Temperature)**: Thermal profiles in °C and urban heat island tracking.
  - Interactive multi-line trend chart showing continuous multi-year trajectories.

### 5. B2B Executive Risk Reports
- **Where**: Tap **Reports** on the navigation bar.
- **How to use**:
  1. Choose a target evaluated site.
  2. Tap **Generate Executive PDF Report**.
  3. A unique report ID (e.g., `SR-RPT-XXXX`) and summary is generated with a dedicated download URL for investment committees.

### 6. NASA Astronomy Picture of the Day (APOD)
- **Where**: Tap **APOD** in the menu/drawer.
- **How to use**: View NASA's daily featured astronomical image, title, date, copyright, and official scientific explanation.

### 7. Settings & Customization
- **Theme Switcher**: Switch between **Deep Space Dark**, **Light Mode**, and **System Default**.
- **Backend URL Configurator**: Switch between local development and cloud endpoints.

---

## 🧪 Running Automated Tests

### Backend Automated Test Suite
Run Django tests to verify all 5 core endpoints:
```bash
cd backend
python manage.py test
```
*Tests verify:*
- ✅ `health_check` endpoint
- ✅ `environmental_indicators` multi-year calculation
- ✅ `site_risk_analysis` MCDA weighted formula
- ✅ `site_comparison` multi-site ranking algorithm
- ✅ `generate_risk_report` generation logic

### Frontend Automated Test Suite
Run Flutter test suite to verify theme provider, settings screens, and widget smoke tests:
```bash
cd mobile
flutter test
```
*Tests verify:*
- ✅ `ThemeProvider` state and persistence
- ✅ `SettingsScreen` UI rendering and theme switches
- ✅ `SpaceRiskApp` widget tree smoke test
- ✅ Code analysis (`flutter analyze` - 0 issues found)
