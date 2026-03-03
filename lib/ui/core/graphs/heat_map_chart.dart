import 'package:flutter/material.dart';
import 'package:cristalyse/cristalyse.dart';
import 'package:elaros_mobile_app/ui/core/graphs/base_chart.dart';

class HeatMapColourGradients {
  static final Map<String, List<Color>> heatMapColourGradients = {
    'whiteToYellowToRed': [Colors.white, Colors.yellow, Colors.red.shade600],
    'blackToYellowToRed': [Colors.black, Colors.yellow, Colors.red.shade600],
    'redToYellowToGreen': [
      Colors.red.shade600,
      Colors.yellow,
      Colors.green.shade600,
    ],
    'greenToYellowToRed': [
      Colors.green.shade600,
      Colors.yellow,
      Colors.red.shade600,
    ],
    'defaultCristalyse': [
      Colors.red.shade200,
      Colors.orange,
      Colors.green.shade600,
    ],
  };
}

class HeatMapChart extends BaseChart {
  const HeatMapChart({
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
    super.yScaleType = ScaleType.ordinal,
    super.xScaleType = ScaleType.ordinal,
    super.yAxisTitle,
    super.xAxisTitle,
  });

  @override
  Widget build(BuildContext context) {
    CristalyseChart chart = buildChart()
        .mappingHeatMap(x: mappingKeyX, y: mappingKeyY, value: mappingKeyColour)
        .geomHeatMap(
          cellSpacing: 2,
          cellAspectRatio: 1,
          cellBorderRadius: BorderRadius.circular(4),
          interpolateColors: true,
          showValues: true,
          colorGradient: darkTheme
              ? HeatMapColourGradients
                    .heatMapColourGradients['blackToYellowToRed']
              : HeatMapColourGradients
                    .heatMapColourGradients['whiteToYellowToRed'],
          valueFormatter: (value) => (value as int).round().toString(),
          valueTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: darkTheme ? Colors.white : Colors.black,
          ),
        );

    return chart.build();
  }
}
