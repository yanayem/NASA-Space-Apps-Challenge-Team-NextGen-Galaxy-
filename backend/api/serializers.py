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
    thermal_anomalies = serializers.IntegerField(default=0, help_text="Detected thermal anomaly events (VIIRS/MODIS)")

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
        ('telecom_tower', 'Telecom Infrastructure Tower'),
        ('data_center', 'Data Center Facility'),
        ('commercial', 'Commercial Complex'),
        ('residential', 'Residential Development'),
    ]
    project_type = serializers.ChoiceField(choices=PROJECT_TYPES, default='warehouse')
    latitude = serializers.FloatField(default=23.8103, help_text="Target site latitude")
    longitude = serializers.FloatField(default=90.4125, help_text="Target site longitude")
    site_name = serializers.CharField(default="Candidate Site", help_text="Name or identifier of the site")

class SubRiskBreakdownSerializer(serializers.Serializer):
    flood_risk = serializers.FloatField(help_text="Flood Risk Score (0-100)")
    heat_risk = serializers.FloatField(help_text="Heat Island Risk Score (0-100)")
    env_change_risk = serializers.FloatField(help_text="Environmental Instability Score (0-100)")
    water_change_risk = serializers.FloatField(help_text="Water Body Volatility Score (0-100)")
    thermal_event_risk = serializers.FloatField(help_text="Thermal / Fire Anomaly Exposure (0-100)")
    site_stability = serializers.FloatField(help_text="Overall Geotechnical & Land Stability Score (0-100)")

class RiskAnalysisResponseSerializer(serializers.Serializer):
    site_name = serializers.CharField()
    location = serializers.DictField()
    project_type = serializers.CharField()
    spacerisk_score = serializers.FloatField(help_text="Overall Weighted SpaceRisk Score (0 to 100)")
    risk_level = serializers.CharField(help_text="Risk Category (Low, Moderate-Low, Moderate, High, Extreme)")
    sub_scores = SubRiskBreakdownSerializer()
    project_adjusted_weights = serializers.DictField(help_text="Risk weights tailored to project type")
    ai_investment_summary = serializers.CharField(help_text="AI generated investment risk recommendation")
    actionable_mitigations = serializers.ListField(child=serializers.CharField())

class LocationItemSerializer(serializers.Serializer):
    site_name = serializers.CharField(default="Site A", help_text="Identifier for the candidate site")
    latitude = serializers.FloatField(default=23.8103)
    longitude = serializers.FloatField(default=90.4125)

class SiteComparisonRequestSerializer(serializers.Serializer):
    project_type = serializers.CharField(default='warehouse', help_text="Infrastructure project type")
    locations = LocationItemSerializer(many=True)

class SiteComparisonResultItemSerializer(serializers.Serializer):
    site_name = serializers.CharField()
    latitude = serializers.FloatField()
    longitude = serializers.FloatField()
    spacerisk_score = serializers.FloatField()
    risk_level = serializers.CharField()
    flood_risk = serializers.FloatField()
    heat_risk = serializers.FloatField()
    water_change = serializers.FloatField()
    env_stability = serializers.FloatField()
    key_recommendation = serializers.CharField()

class SiteComparisonResponseSerializer(serializers.Serializer):
    project_type = serializers.CharField()
    candidate_count = serializers.IntegerField()
    comparison_results = SiteComparisonResultItemSerializer(many=True)
    recommended_site = serializers.CharField(help_text="Optimal candidate site identifier")
    comparison_summary = serializers.CharField(help_text="Executive summary of the site comparison")

class ReportGenerationRequestSerializer(serializers.Serializer):
    site_name = serializers.CharField(default="Dhaka Central Warehouse Site")
    project_type = serializers.CharField(default="warehouse")
    latitude = serializers.FloatField(default=23.8103)
    longitude = serializers.FloatField(default=90.4125)

class ReportGenerationResponseSerializer(serializers.Serializer):
    report_id = serializers.CharField(help_text="Unique report UUID")
    site_name = serializers.CharField()
    generated_at = serializers.CharField()
    download_url = serializers.URLField(help_text="Download link for the PDF report")
    summary = serializers.CharField()
