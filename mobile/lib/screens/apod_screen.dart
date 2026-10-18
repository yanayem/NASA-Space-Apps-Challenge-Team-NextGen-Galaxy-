import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/risk_models.dart';
import '../theme/app_theme.dart';

class ApodScreen extends StatefulWidget {
  const ApodScreen({super.key});

  @override
  State<ApodScreen> createState() => _ApodScreenState();
}

class _ApodScreenState extends State<ApodScreen> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  ApodData? _apodData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchApod();
  }

  Future<void> _fetchApod() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _apiService.fetchApod();
      if (mounted) {
        setState(() {
          _apodData = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Could not retrieve APOD: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.rocket_launch, color: AppTheme.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    'NASA Earth & Space Feed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: context.textSecondary),
                onPressed: _fetchApod,
                tooltip: 'Refresh Feed',
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      'Fetching Astronomy Picture of the Day from NASA...',
                      style: TextStyle(color: context.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: AppTheme.accentAmber),
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: context.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _fetchApod,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (_apodData != null)
            _buildApodCard(_apodData!),
        ],
      ),
    );
  }

  Widget _buildApodCard(ApodData data) {
    return Card(
      color: context.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.cardBorder),
      ),
      elevation: context.isDarkMode ? 0 : 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.url.isNotEmpty)
            Image.network(
              data.url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 240,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: context.subCardBg,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.public, size: 48, color: AppTheme.primaryBlue),
                      const SizedBox(height: 8),
                      Text(
                        'NASA Earth Observation Feed',
                        style: TextStyle(color: context.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        data.date,
                        style: TextStyle(fontSize: 11, color: context.textSecondary),
                      ),
                      backgroundColor: context.subCardBg,
                      side: BorderSide(color: context.cardBorder),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  data.explanation,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
