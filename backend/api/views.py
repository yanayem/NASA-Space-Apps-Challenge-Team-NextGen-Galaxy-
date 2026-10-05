import os
import requests
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

NASA_API_KEY = os.getenv("NASA_API_KEY", "DEMO_KEY")

@api_view(['GET'])
def apod(request):
    """
    Fetch NASA Astronomy Picture of the Day (APOD)
    """
    url = f"https://api.nasa.gov/planetary/apod?api_key={NASA_API_KEY}"
    try:
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            return Response(response.json(), status=status.HTTP_200_OK)
        return Response(
            {"error": "Failed to fetch APOD from NASA API", "details": response.json()},
            status=response.status_code
        )
    except Exception as e:
        return Response(
            {"error": "Server error while connecting to NASA API", "message": str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['GET'])
def health_check(request):
    """
    Backend Health Check API
    """
    return Response({
        "status": "online",
        "app": "NASA Space App Backend",
        "services": ["Django REST Framework", "Firebase Admin", "NASA Open API"]
    })
