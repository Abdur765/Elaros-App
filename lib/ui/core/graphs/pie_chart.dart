import 'package:cristalyse/cristalyse.dart';
import 'package:elaros_mobile_app/ui/core/graphs/base_chart.dart';
import 'package:flutter/material.dart';

class PieChart extends BaseChart {
  final double outerRadius;
  final double innerRadius;
  final bool showLabels;
  final bool showPercentages;
  final double explodeDistance;
  final bool explodeSlices;

  const PieChart({
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
    this.outerRadius = 100,
    this.innerRadius = 0,
    this.showLabels = true,
    this.showPercentages = true,
    this.explodeDistance = 0,
    this.explodeSlices = false,
  });

  @override
  Widget build(BuildContext context) {
    CristalyseChart chart = buildChart()
        .mappingPie(value: mappingKeyY, category: mappingKeyX)
        .geomPie(
          outerRadius: outerRadius,
          innerRadius: innerRadius,
          showLabels: showLabels,
          showPercentages: showPercentages,
          explodeDistance: explodeDistance,
          explodeSlices: explodeSlices,
        );

    return chart.build();
  }
}
