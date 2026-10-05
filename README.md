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

## 🛰️ NASA Data & Earth-System Indicators

SpaceRisk leverages multi-source Earth-observation datasets:
* **Satellite Datasets:** Landsat, Sentinel-2, MODIS, VIIRS, and Global Surface Water datasets.
* **Environmental Indicators Analyzed:**
  * **NDVI (Normalized Difference Vegetation Index):** Monitors vegetation health and deforestation.
  * **NDWI (Normalized Difference Water Index):** Detects surface water dynamics and flood risks.
  * **NDBI (Normalized Difference Built-up Index):** Tracks urban expansion and land transformation.
  * **LST (Land Surface Temperature):** Evaluates thermal profiles and urban heat islands.

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

```
+-------------------------------------------------------+
|                 Flutter Mobile App                    |
|  - Modern Dark Theme Space UI                         |
|  - Firebase Auth & Cloud Messaging                    |
|  - Site Comparison & Trend Visualizations             |
+--------------------------+----------------------------+
                           |
            +--------------+--------------+
            |                             |
            v                             v
+-----------------------+     +-----------------------+
|  Firebase Services    |     | Django REST Backend   |
|  - Firebase Auth      |     | - NASA / ESA API Feed |
|  - Push Notifications |     | - Indicator Analytics |
|  - Cloud Storage      |     | - Trend Computation   |
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

### 2. Mobile Setup (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```
