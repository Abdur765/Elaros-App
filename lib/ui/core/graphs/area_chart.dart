import 'package:flutter/material.dart';
import 'package:cristalyse/cristalyse.dart';
import 'package:elaros_mobile_app/ui/core/graphs/base_chart.dart';

class AreaChart extends BaseChart {
  final double alpha;
  final double strokeWidth;
  final LineStyle lineStyle;
  final YAxis yAxis;
  final bool fillArea;
  final Color? color;

  const AreaChart({
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
    this.alpha = 0.7,
    this.strokeWidth = 0.5,
    this.lineStyle = LineStyle.solid,
    this.yAxis = YAxis.primary,
    this.fillArea = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    CristalyseChart chart = buildChart().geomArea(
      alpha: alpha,
      strokeWidth: strokeWidth,
      style: lineStyle,
      yAxis: yAxis,
      fillArea: fillArea,
      color: color,
    );

    return chart.build();
  }
}
