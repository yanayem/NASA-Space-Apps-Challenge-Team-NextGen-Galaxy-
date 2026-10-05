import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/risk_models.dart';

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
              const Row(
                children: [
                  Icon(Icons.rocket_launch, color: Color(0xFF3B82F6)),
                  SizedBox(width: 8),
                  Text(
                    'NASA Earth & Space Feed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white70),
                onPressed: _fetchApod,
                tooltip: 'Refresh Feed',
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Fetching Astronomy Picture of the Day from NASA...',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: Colors.amber),
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white70),
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
      color: const Color(0xFF151921),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF222938)),
      ),
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
                color: Colors.grey[850],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.public, size: 48, color: Color(0xFF3B82F6)),
                      SizedBox(height: 8),
                      Text(
                        'NASA Earth Observation Feed',
                        style: TextStyle(color: Colors.white70),
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        data.date,
                        style: const TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                      backgroundColor: const Color(0xFF222938),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  data.explanation,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Colors.white70,
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
