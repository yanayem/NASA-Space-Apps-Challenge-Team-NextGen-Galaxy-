import json
import os
import math
import requests

DATASET_PATH = os.path.join(os.path.dirname(__file__), 'dataset', 'nasa_hls_bangladesh.json')

# Verified NASA Earthdata Catalog Collections
NASA_HLS_COLLECTIONS = {
    "HLSL30": {
        "name": "HLS Landsat 30m Surface Reflectance (HLSL30 v2.0)",
        "provider": "LPCLOUD",
        "catalog_url": "https://www.earthdata.nasa.gov/data/catalog/lpcloud-hlsl30-2.0",
        "primary_index": ["NDBI", "Surface Reflectance", "Bands 2-7"]
    },
    "HLSS30": {
        "name": "HLS Sentinel-2 30m Surface Reflectance (HLSS30 v2.0)",
        "provider": "LPCLOUD",
        "catalog_url": "https://www.earthdata.nasa.gov/data/catalog/lpcloud-hlss30-2.0",
        "primary_index": ["NDVI", "NDWI", "Bands B02-B12"]
    },
    "HLSL30_VI": {
        "name": "HLS Landsat Vegetation Indices (HLSL30_VI v2.0)",
        "provider": "LPCLOUD",
        "catalog_url": "https://www.earthdata.nasa.gov/data/catalog/lpcloud-hlsl30-vi-2.0",
        "primary_index": ["NDVI", "EVI", "Vegetation Canopy Health"]
    },
    "OPERA_L3_DSWX-HLS_V1": {
        "name": "OPERA Level-3 Dynamic Surface Water Extent from HLS (DSWx-HLS v1.0)",
        "provider": "POCLOUD",
        "catalog_url": "https://www.earthdata.nasa.gov/data/catalog/pocloud-opera-l3-dswx-hls-v1-1.0",
        "primary_index": ["Surface Water Extent", "Dynamic Inundation", "Flood Hazard"]
    }
}

def load_local_hls_dataset():
    """
    Loads calibrated NASA Harmonized Landsat Sentinel-2 (HLS) indicators for Bangladesh focus regions.
    """
    if os.path.exists(DATASET_PATH):
        try:
            with open(DATASET_PATH, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception:
            return []
    return []

def find_closest_dataset_site(lat, lon):
    """
    Finds closest reference site in the HLS dataset using Euclidean distance.
    """
    sites = load_local_hls_dataset()
    if not sites:
        return None
        
    closest = None
    min_dist = float('inf')
    for s in sites:
        dist = math.hypot(s['latitude'] - lat, s['longitude'] - lon)
        if dist < min_dist:
            min_dist = dist
            closest = s
    return closest

def query_nasa_cmr_multi_collection(lat, lon, limit_per_collection=1):
    """
    Queries live NASA CMR (Common Metadata Repository) across:
    1. LPCLOUD: HLSL30 v2.0
    2. LPCLOUD: HLSS30 v2.0
    3. LPCLOUD: HLSL30_VI v2.0
    4. POCLOUD: OPERA_L3_DSWX-HLS_V1 v1.0
    Docs: https://cmr.earthdata.nasa.gov/search/granules.json
    """
    granules = []
    base_url = "https://cmr.earthdata.nasa.gov/search/granules.json"

    for short_name, meta in NASA_HLS_COLLECTIONS.items():
        try:
            params = {
                "short_name": short_name,
                "provider": meta["provider"],
                "point": f"{lon},{lat}",
                "page_size": limit_per_collection
            }
            resp = requests.get(base_url, params=params, timeout=4)
            if resp.status_code == 200:
                entries = resp.json().get('feed', {}).get('entry', [])
                for item in entries:
                    browse_url = None
                    if item.get('links'):
                        browse_url = item['links'][0].get('href')
                    granules.append({
                        "collection": short_name,
                        "collection_name": meta["name"],
                        "provider": meta["provider"],
                        "catalog_url": meta["catalog_url"],
                        "granule_id": item.get('title'),
                        "time_start": item.get('time_start'),
                        "browse_url": browse_url
                    })
        except Exception:
            continue
            
    # Fallback to general query if point has cloud/spatial latency
    if not granules:
        for short_name, meta in list(NASA_HLS_COLLECTIONS.items())[:2]:
            try:
                resp = requests.get(base_url, params={"short_name": short_name, "provider": meta["provider"], "page_size": 1}, timeout=3)
                if resp.status_code == 200:
                    entries = resp.json().get('feed', {}).get('entry', [])
                    if entries:
                        item = entries[0]
                        granules.append({
                            "collection": short_name,
                            "collection_name": meta["name"],
                            "provider": meta["provider"],
                            "catalog_url": meta["catalog_url"],
                            "granule_id": item.get('title'),
                            "time_start": item.get('time_start'),
                            "browse_url": item.get('links', [{}])[0].get('href') if item.get('links') else None
                        })
            except Exception:
                pass

    return granules
