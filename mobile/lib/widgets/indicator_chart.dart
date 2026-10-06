import 'package:flutter/material.dart';
import '../models/risk_models.dart';

class IndicatorTrendChart extends StatefulWidget {
  final List<IndicatorTrendItem> items;
  final String selectedMetric;

  const IndicatorTrendChart({
    super.key,
    required this.items,
    this.selectedMetric = 'NDVI',
  });

  @override
  State<IndicatorTrendChart> createState() => _IndicatorTrendChartState();
}

class _IndicatorTrendChartState extends State<IndicatorTrendChart> {
  late String _currentMetric;

  @override
  void initState() {
    super.initState();
    _currentMetric = widget.selectedMetric;
  }

  Color _getMetricColor() {
    switch (_currentMetric) {
      case 'NDVI':
        return const Color(0xFF10B981); // Emerald Green (Vegetation)
      case 'NDWI':
        return const Color(0xFF06B6D4); // Cyan Blue (Water)
      case 'NDBI':
        return const Color(0xFFF59E0B); // Amber (Built-up)
      case 'LST':
        return const Color(0xFFEF4444); // Red (Land Surface Temp)
      default:
        return const Color(0xFF3B82F6);
    }
  }

  List<double> _getMetricValues() {
    return widget.items.map((e) {
      switch (_currentMetric) {
        case 'NDVI':
          return e.ndvi;
        case 'NDWI':
          return e.ndwi;
        case 'NDBI':
          return e.ndbi;
        case 'LST':
          return e.lstCelsius;
        default:
          return e.ndvi;
      }
    }).toList();
  }

  String _getMetricUnit() {
    switch (_currentMetric) {
      case 'NDVI':
        return 'Index (-1 to 1)';
      case 'NDWI':
        return 'Index (-1 to 1)';
      case 'NDBI':
        return 'Index (-1 to 1)';
      case 'LST':
        return '°Celsius';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(child: Text("No satellite data points available."));
    }

    final values = _getMetricValues();
    final years = widget.items.map((e) => e.year.toString()).toList();
    final chartColor = _getMetricColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metric Switcher Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('NDVI (Vegetation)', 'NDVI', const Color(0xFF10B981)),
              const SizedBox(width: 8),
              _buildFilterChip('NDWI (Water)', 'NDWI', const Color(0xFF06B6D4)),
              const SizedBox(width: 8),
              _buildFilterChip('NDBI (Built-up)', 'NDBI', const Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              _buildFilterChip('LST (°C Surface Heat)', 'LST', const Color(0xFFEF4444)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF151921),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF222938)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Multi-Year Satellite Trend — $_currentMetric',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getMetricUnit(),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: CustomPaint(
                  painter: _LineChartPainter(
                    values: values,
                    years: years,
                    lineColor: chartColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String key, Color color) {
    final isSelected = _currentMetric == key;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      selectedColor: color.withValues(alpha: 0.8),
      backgroundColor: const Color(0xFF151921),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? color : const Color(0xFF222938),
        ),
      ),
      onSelected: (_) {
        setState(() {
          _currentMetric = key;
        });
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> years;
  final Color lineColor;

  _LineChartPainter({
    required this.values,
    required this.years,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final double paddingBottom = 24.0;
    final double paddingTop = 16.0;
    final double chartHeight = size.height - paddingBottom - paddingTop;
    final double chartWidth = size.width;

    double minVal = values.reduce((a, b) => a < b ? a : b);
    double maxVal = values.reduce((a, b) => a > b ? a : b);

    if (minVal == maxVal) {
      maxVal += 1.0;
      minVal -= 1.0;
    }

    // Grid lines background
    final gridPaint = Paint()
      ..color = const Color(0xFF222938)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 3; i++) {
      double y = paddingTop + (chartHeight / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    final dx = chartWidth / (values.length - 1);
    List<Offset> points = [];

    for (int i = 0; i < values.length; i++) {
      double normalized = (values[i] - minVal) / (maxVal - minVal);
      double y = paddingTop + chartHeight - (normalized * chartHeight);
      double x = i * dx;
      points.add(Offset(x, y));
    }

    // Draw Line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Draw Gradient fill below line
    final fillPath = Path.from(path)
      ..lineTo(chartWidth, size.height - paddingBottom)
      ..lineTo(0, size.height - paddingBottom)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.35),
          lineColor.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw Points & Labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < points.length; i++) {
      // Circle point
      canvas.drawCircle(
        points[i],
        5.0,
        Paint()..color = lineColor,
      );
      canvas.drawCircle(
        points[i],
        2.5,
        Paint()..color = Colors.white,
      );

      // Year Label below
      textPainter.text = TextSpan(
        text: years[i],
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - textPainter.width / 2, size.height - 14),
      );

      // Value label above point
      textPainter.text = TextSpan(
        text: values[i].toStringAsFixed(2),
        style: TextStyle(
          color: lineColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - textPainter.width / 2, points[i].dy - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.lineColor != lineColor;
  }
}
