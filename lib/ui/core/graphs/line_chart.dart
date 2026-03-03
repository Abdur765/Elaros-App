import 'package:cristalyse/cristalyse.dart';
import 'package:elaros_mobile_app/ui/core/graphs/base_chart.dart';
import 'package:flutter/material.dart';

class LineChart extends BaseChart {
  final double strokeWidth;
  final LineStyle lineStyle;
  final YAxis yAxis;

  const LineChart({
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
    this.strokeWidth = 2.0,
    this.lineStyle = LineStyle.solid,
    this.yAxis = YAxis.primary,
  });

  @override
  Widget build(BuildContext context) {
    CristalyseChart chart = buildChart().geomLine(
      style: lineStyle,
      strokeWidth: strokeWidth,
      yAxis: yAxis,
    );

    return chart.build();
  }
}
