import 'package:flutter/material.dart';
import 'package:cristalyse/cristalyse.dart';
import 'package:elaros_mobile_app/ui/core/graphs/base_chart.dart';

class BarChart extends BaseChart {
  final BarStyle barStyle;
  final bool horizontalBars;
  final BorderRadius borderRadius;
  final double barWidth;
  final double barAlpha;
  final bool roundOutwardEdges;
  final double borderWidth;

  const BarChart({
    super.key,
    required super.data,
    required super.mappingKeyX,
    required super.mappingKeyY,
    super.mappingKeyColour,
    super.darkTheme,
    super.legendPosition,
    super.labelXMap,
    super.labelYMap,
    super.yScaleMin,
    super.xScaleMin,
    super.yScaleMax,
    super.xScaleMax,
    super.yScaleType,
    super.xScaleType,
    super.yAxisTitle,
    super.xAxisTitle,
    this.barStyle = BarStyle.grouped,
    this.horizontalBars = false,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(8)),
    this.barWidth = 0.4,
    this.barAlpha = 0.7,
    this.roundOutwardEdges = true,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    CristalyseChart chart = buildChart().geomBar(
      width: barWidth,
      alpha: barAlpha,
      style: barStyle,
      borderRadius: borderRadius,
      roundOutwardEdges: roundOutwardEdges,
      borderWidth: borderWidth,
    );

    if (horizontalBars) chart.coordFlip();

    return chart.build();
  }
}
