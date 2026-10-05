from rest_framework import serializers

class HealthCheckResponseSerializer(serializers.Serializer):
    status = serializers.CharField(help_text="Status of the backend server (e.g. online)")
    app = serializers.CharField(help_text="Application name")
    services = serializers.ListField(
        child=serializers.CharField(),
        help_text="List of active integrated services"
    )

class ApodResponseSerializer(serializers.Serializer):
    title = serializers.CharField(help_text="Title of the picture")
    explanation = serializers.CharField(help_text="Explanation of the picture")
    url = serializers.URLField(help_text="URL of the image")
    hdurl = serializers.URLField(required=False, help_text="High Definition URL")
    date = serializers.CharField(help_text="Date in YYYY-MM-DD")
    media_type = serializers.CharField(help_text="Media type (image/video)")

class IndicatorRequestSerializer(serializers.Serializer):
    latitude = serializers.FloatField(default=23.8103, help_text="Latitude of the location")
    longitude = serializers.FloatField(default=90.4125, help_text="Longitude of the location")
    start_year = serializers.IntegerField(default=2018, help_text="Start year for trend analysis")
    end_year = serializers.IntegerField(default=2024, help_text="End year for trend analysis")

class IndicatorTrendItemSerializer(serializers.Serializer):
    year = serializers.IntegerField(help_text="Year of observation")
    ndvi = serializers.FloatField(help_text="Normalized Difference Vegetation Index (-1 to 1)")
    ndwi = serializers.FloatField(help_text="Normalized Difference Water Index (-1 to 1)")
    ndbi = serializers.FloatField(help_text="Normalized Difference Built-up Index (-1 to 1)")
    lst_celsius = serializers.FloatField(help_text="Land Surface Temperature in Celsius")

class IndicatorResponseSerializer(serializers.Serializer):
    location = serializers.DictField(help_text="Target location metadata")
    period = serializers.CharField(help_text="Analyzed multi-year period")
    indicators = IndicatorTrendItemSerializer(many=True)
    summary = serializers.CharField(help_text="Summary of observed satellite trends")

class RiskAnalysisRequestSerializer(serializers.Serializer):
    PROJECT_TYPES = [
        ('warehouse', 'Warehouse / Logistics Hub'),
        ('factory', 'Industrial Factory'),
        ('solar_farm', 'Solar Power Farm'),
        ('commercial', 'Commercial Complex'),
        ('residential', 'Residential Development'),
    ]
    project_type = serializers.ChoiceField(choices=PROJECT_TYPES, default='warehouse')
    latitude = serializers.FloatField(default=23.8103, help_text="Target site latitude")
    longitude = serializers.FloatField(default=90.4125, help_text="Target site longitude")

class RiskAnalysisResponseSerializer(serializers.Serializer):
    location = serializers.DictField()
    project_type = serializers.CharField()
    overall_risk_score = serializers.FloatField(help_text="Risk score (0 to 100)")
    risk_level = serializers.CharField(help_text="Risk category (Low/Moderate/High)")
    risk_factors = serializers.ListField(child=serializers.DictField())
    recommendation = serializers.CharField(help_text="Actionable mitigation recommendations")

class LocationItemSerializer(serializers.Serializer):
    site_name = serializers.CharField(default="Site A", help_text="Identifier for the candidate site")
    latitude = serializers.FloatField(default=23.8103)
    longitude = serializers.FloatField(default=90.4125)

class SiteComparisonRequestSerializer(serializers.Serializer):
    project_type = serializers.CharField(default='warehouse', help_text="Infrastructure type")
    locations = LocationItemSerializer(many=True)

class SiteComparisonResponseSerializer(serializers.Serializer):
    project_type = serializers.CharField()
    comparison_results = serializers.ListField(child=serializers.DictField())
    best_option = serializers.CharField(help_text="Recommended optimal site name")
