import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchApod();
  }

  String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _fetchApod({String? dateStr}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _apiService.fetchApod(date: dateStr);
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

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(1995, 6, 16);
    final initialDate = _selectedDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: firstDate,
      lastDate: now,
      helpText: 'SELECT NASA APOD DATE',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchApod(dateStr: _formatDate(picked));
    }
  }

  void _fetchRandom() {
    final now = DateTime.now();
    final start = DateTime(2005, 1, 1);
    final randomDays = Random().nextInt(now.difference(start).inDays);
    final randomDate = start.add(Duration(days: randomDays));
    setState(() {
      _selectedDate = randomDate;
    });
    _fetchApod(dateStr: _formatDate(randomDate));
  }

  String? _getYouTubeThumbnail(String url) {
    if (url.contains('youtube.com/embed/')) {
      final id = url.split('youtube.com/embed/').last.split('?').first;
      return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
    } else if (url.contains('youtu.be/')) {
      final id = url.split('youtu.be/').last.split('?').first;
      return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
    }
    return null;
  }

  void _showHdImageDialog(String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            Flexible(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'Failed to load HD Image',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.rocket_launch, color: AppTheme.primaryBlue),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'NASA Earth & Space Feed',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    color: AppTheme.primaryBlue,
                    tooltip: 'Select Date',
                    onPressed: _selectDate,
                  ),
                  IconButton(
                    icon: const Icon(Icons.shuffle),
                    color: AppTheme.accentCyan,
                    tooltip: 'Discover Random APOD',
                    onPressed: _fetchRandom,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: context.textSecondary),
                    onPressed: () => _fetchApod(
                      dateStr: _selectedDate != null ? _formatDate(_selectedDate!) : null,
                    ),
                    tooltip: 'Refresh Feed',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Date Filter Badge
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Chip(
                    avatar: const Icon(Icons.event, size: 16),
                    label: Text('Date: ${_formatDate(_selectedDate!)}'),
                    onDeleted: () {
                      setState(() {
                        _selectedDate = null;
                      });
                      _fetchApod();
                    },
                    backgroundColor: context.subCardBg,
                  ),
                ],
              ),
            ),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Fetching Astronomy Picture of the Day from NASA...',
                      style: TextStyle(color: context.textSecondary, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_off, size: 48, color: AppTheme.accentAmber),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: context.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Retry'),
                          onPressed: () => _fetchApod(),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.shuffle, size: 18),
                          label: const Text('Random APOD'),
                          onPressed: _fetchRandom,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else if (_apodData != null)
            _buildApodCard(_apodData!),
        ],
      ),
    );
  }

  Widget _buildApodCard(ApodData data) {
    final isVideo = data.mediaType.toLowerCase() == 'video';
    final youtubeThumb = isVideo ? _getYouTubeThumbnail(data.url) : null;
    final displayImageUrl = isVideo ? (youtubeThumb ?? '') : data.url;

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
          // Media Header
          if (displayImageUrl.isNotEmpty)
            GestureDetector(
              onTap: () {
                final hd = data.hdurl ?? displayImageUrl;
                if (!isVideo && hd.isNotEmpty) {
                  _showHdImageDialog(hd, data.title);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    displayImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 260,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: context.subCardBg,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isVideo ? Icons.ondemand_video : Icons.public,
                              size: 48,
                              color: AppTheme.primaryBlue,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isVideo ? 'NASA Video Content' : 'NASA Earth Observation Feed',
                              style: TextStyle(color: context.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isVideo)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow, size: 48, color: Colors.white),
                    ),
                  if (!isVideo && (data.hdurl != null || data.url.isNotEmpty))
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.zoom_in, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Tap for HD',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            Container(
              height: 180,
              color: context.subCardBg,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.public, size: 48, color: AppTheme.primaryBlue),
                    const SizedBox(height: 8),
                    Text(
                      'NASA Earth & Space Observation Feed',
                      style: TextStyle(color: context.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

          // Content Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Chip(
                          avatar: Icon(
                            isVideo ? Icons.videocam : Icons.image,
                            size: 14,
                            color: context.textSecondary,
                          ),
                          label: Text(
                            data.date,
                            style: TextStyle(fontSize: 11, color: context.textSecondary),
                          ),
                          backgroundColor: context.subCardBg,
                          side: BorderSide(color: context.cardBorder),
                        ),
                      ],
                    ),
                  ],
                ),

                if (isVideo) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accentCyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentCyan.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppTheme.accentCyan, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This NASA APOD item is a video: ${data.url}',
                            style: TextStyle(fontSize: 12, color: context.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          tooltip: 'Copy Link',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: data.url));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Video link copied to clipboard!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                Text(
                  data.explanation,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: context.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // Actions Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified, size: 16, color: AppTheme.primaryBlue),
                        const SizedBox(width: 6),
                        Text(
                          'Official NASA Telemetry Feed',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, size: 18),
                      tooltip: 'Copy APOD Details',
                      onPressed: () {
                        final text = '${data.title}\n\nDate: ${data.date}\n\n${data.explanation}\n\nSource: ${data.url}';
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('APOD content copied to clipboard!')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
