import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';

enum ScaleType { continuous, ordinal }

abstract class BaseChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  final String mappingKeyX;
  final String mappingKeyY;
  final String? mappingKeyColour;

  final bool darkTheme;

  final LegendPosition? legendPosition;
  final LabelCallback? labelYMap;
  final LabelCallback? labelXMap;

  final double? yScaleMin;
  final double? yScaleMax;
  final double? xScaleMin;
  final double? xScaleMax;

  final ScaleType yScaleType;
  final ScaleType xScaleType;

  final String? yAxisTitle;
  final String? xAxisTitle;

  const BaseChart({
    super.key,
    required this.data,
    required this.mappingKeyX,
    required this.mappingKeyY,
    this.mappingKeyColour,
    this.darkTheme = true,
    this.legendPosition = LegendPosition.bottom,
    this.labelYMap,
    this.labelXMap,
    this.yScaleMin,
    this.xScaleMin,
    this.yScaleMax,
    this.xScaleMax,
    this.yScaleType = ScaleType.continuous,
    this.xScaleType = ScaleType.continuous,
    this.yAxisTitle,
    this.xAxisTitle,
  });

  CristalyseChart buildChart() {
    final ChartTheme customThemeLight = ChartTheme(
      backgroundColor: const Color(0xFFF8F9FA),
      plotBackgroundColor: Colors.white,
      primaryColor: const Color(0xFF007ACC), // Brand blue
      borderColor: const Color(0xFFE1E5E9),
      gridColor: const Color(0xFFF1F3F4),
      axisColor: const Color(0xFF5F6368),
      gridWidth: 0.5,
      axisWidth: 1.2,
      pointSizeDefault: 5.0,
      pointSizeMin: 3.0,
      pointSizeMax: 15.0,
      colorPalette: [
        const Color(0xFF007ACC), // Primary blue
        const Color(0xFFFF6B35), // Orange accent
        const Color(0xFF28A745), // Success green
        const Color(0xFFDC3545), // Warning red
        const Color(0xFF6F42C1), // Purple
        const Color(0xFF20C997), // Teal
      ],
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
      axisTextStyle: const TextStyle(
        fontSize: 11,
        color: Color(0xFF5F6368),
        fontWeight: FontWeight.w500,
      ),
      axisLabelStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFF202124),
        fontWeight: FontWeight.w600,
      ),
    );
    final ChartTheme customThemeDark = ChartTheme(
      backgroundColor: Colors.black38,
      plotBackgroundColor: Colors.black45,
      primaryColor: Colors.teal,
      borderColor: Colors.black38,
      gridColor: Colors.black26,
      axisColor: Colors.black38,
      gridWidth: 1,
      axisWidth: 1,
      pointSizeDefault: 5.0,
      pointSizeMin: 3.0,
      pointSizeMax: 15.0,
      colorPalette: [
        const Color(0xFF007ACC),
        const Color(0xFFFF6B35),
        const Color(0xFF28A745),
        const Color(0xFFDC3545),
        const Color(0xFF6F42C1),
        const Color(0xFF20C997),
      ],
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
      axisTextStyle: const TextStyle(
        fontSize: 11,
        color: Color(0xFF5F6368),
        fontWeight: FontWeight.w500,
      ),
      axisLabelStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFF202124),
        fontWeight: FontWeight.w600,
      ),
    );

    CristalyseChart chart = CristalyseChart()
        .data(data)
        .mapping(x: mappingKeyX, y: mappingKeyY, color: mappingKeyColour ?? '')
        .theme(darkTheme ? customThemeDark : customThemeLight);

    if (legendPosition != null) chart.legend(position: legendPosition);

    if (yScaleType == ScaleType.ordinal) {
      chart.scaleYOrdinal(labels: labelYMap, title: yAxisTitle ?? mappingKeyY);
    } else {
      chart.scaleYContinuous(
        min: yScaleMin,
        max: yScaleMax,
        labels: labelYMap,
        title: yAxisTitle ?? mappingKeyY,
      );
    }

    if (xScaleType == ScaleType.ordinal) {
      chart.scaleXOrdinal(labels: labelXMap, title: xAxisTitle ?? mappingKeyX);
    } else {
      chart.scaleXContinuous(
        min: xScaleMin,
        max: xScaleMax,
        labels: labelXMap,
        title: xAxisTitle ?? mappingKeyX,
      );
    }

    return chart;
  }
}
