import 'package:cristalyse/cristalyse.dart';
import 'package:elaros_mobile_app/ui/core/graphs/base_chart.dart';
import 'package:flutter/material.dart';

class ScatterChart extends BaseChart {
  final PointShape pointShape;
  final double pointSize;
  final double pointAlpha;
  final double pointBorderWidth;
  final YAxis yAxis;

  const ScatterChart({
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
    this.pointShape = PointShape.circle,
    this.pointSize = 8.0,
    this.pointAlpha = 0.8,
    this.pointBorderWidth = 1.5,
    this.yAxis = YAxis.primary,
  });

  @override
  Widget build(BuildContext context) {
    CristalyseChart chart = buildChart().geomPoint(
      size: pointSize,
      alpha: pointAlpha,
      shape: pointShape,
      borderWidth: pointBorderWidth,
      yAxis: yAxis,
    );

    return chart.build();
  }
}
