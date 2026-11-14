# NextGen Galaxy — SpaceRisk 🌌

> **Before You Build. Know the Risk.**

A location intelligence platform powered by Earth-observation data to help decision-makers evaluate long-term environmental trends before making major infrastructure investments.

---

## 👥 Team NextGen Galaxy

| Name | Role |
| :--- | :--- |
| **Yeasin Arafat Nayem** | Team Leader & Backend Developer |
| **Himel Mhamud** | Co-Leader & Flutter Developer |
| **Arefa Rhaman** | Presenter, Research & Documentation |
| **Mijanur Rhaman Hrido** | Flutter Developer |
| **Dipto Dey** | Dataset Analyst & Videographer |
| **Sayma Rhaman Eva** | Researcher & Documentation Lead |

---

## 🎯 Core Story & Central Message

```
Today ───► Past ───► Present ───► Trends ───► Decision
```

* **Today** tells us what a place looks like right now.
* **Historical Earth-observation data** helps us understand what changed.
* **Current trends** help us understand what is becoming.
* **SpaceRisk** brings these insights together to empower sustainable, risk-aware infrastructure decisions.

> **Central Message:** SpaceRisk uses Earth-observation data to investigate how locations change over time and turns those trends into understandable location intelligence.

---

## 🚨 The Problem & The Big Idea

### The Problem
When companies or governments plan major infrastructure (warehouses, factories, solar farms), they traditionally focus on current conditions: affordable land, road access, and current mapping imagery. However, a single snapshot cannot reveal critical environmental trajectories—such as rising surface water, land-surface temperature surges, or rapid loss of vegetation.

### The Big Idea
Instead of asking only *"What does this location look like?"*, SpaceRisk asks:
1. *"What has changed here over the past several years?"*
2. *"What is changing right now?"*
3. *"What could those changes mean before we build?"*

---

## 🛰️ Integrated NASA Datasets & Earth-Observation Catalogs

SpaceRisk integrates live NASA Earthdata catalogs, satellite metadata APIs, and multi-year temporal datasets:

### 1. NASA Harmonized Landsat and Sentinel-2 (HLS) Surface Reflectance
* **`HLSL30 v2.0` (LPCLOUD):** Landsat 30m Surface Reflectance — Used for **NDBI** (Built-up Index) and urban expansion tracking.
  * [Catalog Link](https://www.earthdata.nasa.gov/data/catalog/lpcloud-hlsl30-2.0)
* **`HLSS30 v2.0` (LPCLOUD):** Sentinel-2 30m Surface Reflectance — Used for **NDVI** (Vegetation Canopy Index) and **NDWI** (Water Index).
  * [Catalog Link](https://www.earthdata.nasa.gov/data/catalog/lpcloud-hlss30-2.0)
* **`HLSL30_VI v2.0` (LPCLOUD):** Landsat Vegetation Indices — Tracks deforestation and canopy degradation.
  * [Catalog Link](https://www.earthdata.nasa.gov/data/catalog/lpcloud-hlsl30-vi-2.0)

### 2. OPERA Dynamic Surface Water Extent
* **`OPERA_L3_DSWX-HLS_V1` (POCLOUD):** OPERA Level-3 Surface Water Extent from HLS — Detects dynamic inundation, seasonal flood hazards, and surface water body changes.
  * [Catalog Link](https://www.earthdata.nasa.gov/data/catalog/pocloud-opera-l3-dswx-hls-v1-1.0)

### 3. Thermal & Active Fire Hotspot Datasets
* **MODIS Terra/Aqua & VIIRS (VNP14A1):** Analyzes Land Surface Temperature (LST in °C), thermal anomalies, and urban heat island effects.

### 4. NASA CMR (Common Metadata Repository) Live Granule API
* **Real-Time CMR Search Endpoint:** `https://cmr.earthdata.nasa.gov/search/granules.json`
* Automatically queries real-time granules, acquisition timestamps, browse images, and metadata for any selected latitude/longitude coordinate across `LPCLOUD` and `POCLOUD` providers.

### 5. NASA APOD API (Astronomy Picture of the Day)
* Live feed integrated via `api.nasa.gov/planetary/apod` using official authorization key.

### 6. Calibrated Benchmark Historical Dataset (`nasa_hls_bangladesh.json`)
* Multi-year (2018–2024) time-series benchmarks for key industrial corridors (Dhaka Central, Chattogram Port, Gazipur Solar Zone, Khulna Coastal Belt, Sylhet Energy Hub, etc.) calculating multi-spectral indices (NDVI, NDWI, NDBI, LST).

---

## 📍 Focus Region

Our initial deployment focuses on **Bangladesh**—a region experiencing rapid urbanization, industrial expansion, and significant exposure to environmental change and water-related risks. SpaceRisk helps responsible planners assess long-term site viability before committing heavy infrastructure investment.

---

## 🎬 240-Second Video Script (Single Narrator)

### **0:00–0:20 — Hook / Attention**
> Before we build a warehouse, a factory, a solar farm, or any major infrastructure, we usually ask one simple question: *Is this a good location?* But what if we are looking at that location only as it is today? What if the real story is hidden in how that place has changed over the past several years? Today tells us what a place looks like. Trends can tell us what a place is becoming.

### **0:20–0:50 — Who We Are**
> We are NextGen Galaxy, a team bringing together software development, research, data analysis, and visual storytelling. I’m Arefa Rhaman, and I’ll be presenting our project on behalf of the team. Let me introduce you to my teammates: Yeasin Arafat Nayem, our Team Leader and Backend Developer; Himel Mhamud, our Co-Leader and Flutter Developer; Mijanur Rhaman Hrido, our Flutter Developer; Dipto Dey, our Dataset Analyst and Videographer; and Sayma Rhaman Eva, our Researcher and Documentation Lead. I’m also responsible for research and documentation. Together, we asked ourselves a simple question: Can we understand environmental change before it becomes a bigger problem?

### **0:50–1:35 — Why / The Problem**
> Imagine a company wants to build a warehouse. They find affordable land, there is good road access, and the location looks perfect on the map. So, they make the investment. But what if this area has experienced increasing surface water over the years? What if land-surface temperatures have been rising? What if vegetation has been declining? What if the surrounding land has been rapidly changing? A single image may show us what the location looks like today, but it does not necessarily tell us the story of how that location got there. And when infrastructure is designed to remain for many years, understanding that history can be just as important as understanding the location itself.

### **1:35–2:00 — The Big Idea**
> That is where our idea began. Instead of asking only, “What does this location look like?” we wanted to ask, “What has changed here?” “What is changing now?” And most importantly, “What could those changes mean before we build?” That idea became SpaceRisk.

### **2:00–2:40 — What Is SpaceRisk?**
> SpaceRisk is a location intelligence platform designed to help users understand environmental trends at potential infrastructure sites. A user can select the type of project they are planning and choose a location on the map. SpaceRisk then brings different environmental indicators together in one place. Instead of giving users a complicated collection of satellite images, we want to turn that information into something people can actually understand and use when evaluating a potential site.

### **2:40–3:10 — NASA Data and Earth-System Trends**
> At the heart of SpaceRisk is Earth-observation data. We use datasets such as Landsat, Sentinel-2, MODIS, VIIRS, and surface-water data to study environmental changes over time. From these datasets, we analyze indicators such as NDVI for vegetation, NDWI for water, NDBI for built-up areas, and land-surface temperature for heat. By studying these indicators across time, we can move from raw Earth-observation data to meaningful environmental trends. Our goal is to understand not only what is happening at a location, but also how those conditions have changed over time.

### **3:10–3:35 — Demo and Site Comparison**
> But understanding one location is only part of the decision. A business may have several possible sites. SpaceRisk is designed to allow users to compare locations across different environmental factors and understand where the differences are. For example, one site may have a different water trend, vegetation condition, or heat profile than another. By bringing these factors together, SpaceRisk can help users understand the environmental trade-offs before committing to a major infrastructure investment.

### **3:35–3:50 — Why It Matters**
> We also want to begin with a problem that is close to us. Our initial focus is Bangladesh, including rapidly developing areas, industrial zones, and regions affected by environmental change and water-related risks. As cities and infrastructure continue to grow, understanding environmental conditions before construction can become an important part of responsible planning. Our goal is to make complex Earth-observation information easier to access, understand, and use.

### **3:50–4:00 — Final Message**
> Because when you are deciding where to build, looking at today is not always enough. Don’t just ask where you can build. Ask what you are building into.
> **SpaceRisk — Before You Build. Know the Risk.**

---

## 🏗️ Architecture & Technology Stack

SpaceRisk is **much more than just a basic Flutter & Django app**—it is a full-stack Earth-observation intelligence ecosystem combining NASA satellite pipelines, AI/NLG processing, and cloud distribution:

### 1. 📱 Frontend & Visualization (Mobile):
- **Flutter (Dart):** Cross-platform high-performance UI framework.
- **Interactive Map Engine:** Precise Lat/Lon coordinates selection & polygon boundaries.
- **FL Chart & Custom Gauges:** Interactive multi-year time-series trend plotting (NDVI, NDWI, NDBI, LST).

### 2. ⚙️ Core Engine & Cloud Backend:
- **Django REST Framework (DRF):** Robust Python RESTful API core.
- **drf-spectacular (OpenAPI 3.0):** Interactive Swagger UI & ReDoc API documentation.
- **Render Cloud Platform:** Production WSGI cloud hosting with 24/7 uptime.
- **Gunicorn & WhiteNoise:** High-concurrency application server and static assets delivery.

### 3. 🛰️ Satellite Pipelines & NASA Datasets:
- **NASA Harmonized Landsat and Sentinel-2 (HLS):** 30m resolution Surface Reflectance (`HLSL30` / `HLSS30`).
- **OPERA Water Extent:** Level-3 DSWx-HLS dynamic inundation data.
- **NASA CMR Live Search API:** Real-time granule metadata queries.
- **NASA APOD API:** Live daily astronomy feed.
- **MODIS & VIIRS:** Surface thermal anomalies and Land Surface Temperature (LST).

### 4. 🤖 AI, NLP & Export Services:
- **Natural Language Generation (NLG):** Automated AI investment risk summaries & engineering mitigations.
- **Project Weighting Algorithm:** Tailored risk matrix (Warehouse, Factory, Solar Farm, Data Center, Telecom).
- **B2B PDF Report Engine:** Automated executive report generation.
- **Firebase Admin & FCM:** Push notification alerts & cloud auth verification.

---

## 🎨 B2B Enterprise Design System & Dual Theme Palette

SpaceRisk avoids generic consumer AI gradients in favor of a mature **B2B Financial & Location Intelligence UI**—matching the clean standards of Palantir, Stripe, McKinsey Analytics, and ArcGIS Enterprise:

### 1. ☀️ Primary Theme: Executive Enterprise Light Mode (Main B2B Focus)
Designed for investment committees, infrastructure planners, and corporate decision-makers who require maximum readability and financial-report clarity.
- **Page Background:** `#F8FAFC` *(Off-White Slate)*
- **Card & Container Surface:** `#FFFFFF` *(Pure White with 1px `#E2E8F0` border & soft shadow)*
- **Typography & Headers:** `#0F172A` *(Deep Sapphire Slate for crisp legibility)*
- **Brand Primary Accent:** `#2563EB` *(Corporate Trust Blue)*
- **Secondary Highlight Surface:** `#EFF6FF` *(Soft Blue Tint Container)*
- **Financial Risk System Indicators:**
  - 🟢 **Low Risk (Safe Investment):** `#059669` *(Emerald Green)*
  - 🟡 **Moderate Risk (Caution / Mitigations Needed):** `#D97706` *(Amber Gold)*
  - 🔴 **High / Extreme Risk (Severe Exposure):** `#DC2626` *(Crimson Red)*

### 2. 🌙 Secondary Theme: Night Control Center Dark Mode
Designed for field operations, low-light environments, and night-shift monitoring.
- **Page Background:** `#0F172A` *(Slate 900)*
- **Card & Container Surface:** `#1E293B` *(Slate 800 with `#334155` border)*
- **Typography & Headers:** `#F8FAFC` *(Crisp Slate White)*
- **Brand Primary Accent:** `#3B82F6` *(Control Blue)*

### 📊 B2B Visual Elements & Layout Guidelines:
- **Executive Summary Badge:** Clean white card displaying the SpaceRisk score (`42.5 / 100`) alongside high-contrast status tags (`[ MODERATE RISK ]`).
- **Side-by-Side Comparison Matrix:** Financial-grade tabular data grid comparing 2 to 5 candidate sites.
- **High-Contrast Trend Line Charts:** Sharp multi-year trend visualization for NDVI, NDWI, NDBI, and LST.
- **Actionable Mitigation Cards:** Highlighted callouts offering clear, natural-language engineering recommendations.

---

## 📂 Project Structure

```
Nasa Space App/
├── mobile/                  # Flutter mobile application
│   ├── lib/main.dart        # SpaceRisk mobile UI
│   └── pubspec.yaml         # Dependencies (http, firebase_core, provider, etc.)
├── backend/                 # Django REST Framework backend
│   ├── api/                 # REST views, indicators & trend endpoints
│   └── backend/             # Settings, URLs, and Firebase Admin config
├── .gitignore               # Multi-platform git ignore rule set
└── README.md                # Project documentation & script
```

---

## 🚀 Quick Setup Instructions

### 1. Backend Setup (Django REST Framework)

```bash
cd backend
python -m venv venv

# On Windows (PowerShell):
.\venv\Scripts\Activate.ps1

pip install django djangorestframework django-cors-headers firebase-admin requests python-dotenv

# Run migrations & start server
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

### 🌐 Live Production Backend (Render Cloud)
- **Live Base API:** [https://spacerisk.onrender.com/api/](https://spacerisk.onrender.com/api/)
- **Live Swagger UI:** [https://spacerisk.onrender.com/swagger/](https://spacerisk.onrender.com/swagger/)
- **Live ReDoc UI:** [https://spacerisk.onrender.com/redoc/](https://spacerisk.onrender.com/redoc/)

### 📚 Interactive API Documentation

Access interactive Swagger UI and Redoc API documentation locally or on cloud:
- **Swagger UI (Cloud):** [https://spacerisk.onrender.com/swagger/](https://spacerisk.onrender.com/swagger/)
- **Swagger UI (Local):** [http://localhost:8000/swagger/](http://localhost:8000/swagger/)
- **ReDoc UI (Cloud):** [https://spacerisk.onrender.com/redoc/](https://spacerisk.onrender.com/redoc/)
- **ReDoc UI (Local):** [http://localhost:8000/redoc/](http://localhost:8000/redoc/)
- **OpenAPI Schema:** [https://spacerisk.onrender.com/api/schema/](https://spacerisk.onrender.com/api/schema/)

#### Designed Endpoints:
- `GET /api/health/` — Backend & NASA connection status
- `GET /api/apod/` — NASA Astronomy Picture of the Day
- `POST /api/indicators/` — Multi-year NDVI, NDWI, NDBI, and LST satellite trend calculations
- `POST /api/risk-analysis/` — SpaceRisk site evaluation for project types (warehouse, factory, solar farm)
- `POST /api/site-comparison/` — Side-by-side comparison of candidate infrastructure sites


### 2. Mobile Setup (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```
