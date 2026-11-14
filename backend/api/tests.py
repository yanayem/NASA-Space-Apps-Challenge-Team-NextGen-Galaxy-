from django.test import SimpleTestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status

class SpaceRiskAPITests(SimpleTestCase):
    def setUp(self):
        self.client = APIClient()

    def test_health_check(self):
        url = reverse('health_check')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data.get('status'), 'online')
        self.assertIn('services', response.data)

    def test_environmental_indicators(self):
        url = reverse('environmental_indicators')
        payload = {
            'latitude': 23.8103,
            'longitude': 90.4125,
            'start_year': 2018,
            'end_year': 2024
        }
        response = self.client.post(url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('indicators', response.data)
        self.assertIn('location', response.data)
        self.assertGreaterEqual(len(response.data['indicators']), 1)
        self.assertIn('ndvi', response.data['indicators'][0])
        self.assertIn('ndwi', response.data['indicators'][0])
        self.assertIn('lst_celsius', response.data['indicators'][0])

    def test_site_risk_analysis(self):
        url = reverse('site_risk_analysis')
        payload = {
            'site_name': 'Chattogram Industrial Zone',
            'latitude': 22.3569,
            'longitude': 91.7832,
            'project_type': 'warehouse'
        }
        response = self.client.post(url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('spacerisk_score', response.data)
        self.assertIn('risk_level', response.data)
        self.assertIn('sub_scores', response.data)
        self.assertIn('actionable_mitigations', response.data)

    def test_site_comparison(self):
        url = reverse('site_comparison')
        payload = {
            'locations': [
                {'site_name': 'Site Alpha', 'latitude': 23.81, 'longitude': 90.41},
                {'site_name': 'Site Beta', 'latitude': 22.35, 'longitude': 91.78}
            ],
            'project_type': 'factory'
        }
        response = self.client.post(url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('comparison_results', response.data)
        self.assertEqual(len(response.data['comparison_results']), 2)
        self.assertIn('recommended_site', response.data)

    def test_generate_risk_report(self):
        url = reverse('generate_risk_report')
        payload = {
            'site_name': 'Sylhet Eco Park',
            'latitude': 24.8949,
            'longitude': 91.8687,
            'project_type': 'solar_farm'
        }
        response = self.client.post(url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('report_id', response.data)
        self.assertIn('download_url', response.data)
        self.assertIn('summary', response.data)
