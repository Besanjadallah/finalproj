import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminInsightsPage extends StatelessWidget {
  final List<Map<String, dynamic>> shopSales = [
    {
      'shop': 'Green Garden',
      'sales': 250,
      'topItem': 'Basil Plant',
    },
    {
      'shop': 'EcoPlants',
      'sales': 180,
      'topItem': 'Snake Plant',
    },
    {
      'shop': 'Cactus World',
      'sales': 120,
      'topItem': 'Mini Cactus',
    },
    {
      'shop': 'Leafy Lane',
      'sales': 90,
      'topItem': 'Fern',
    },
    {
      'shop': 'Bloom Bazaar',
      'sales': 210,
      'topItem': 'Orchid',
    },
  ];

  AdminInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    int totalSales = shopSales.fold<int>(0, (sum, item) => sum + (item['sales'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        title: const Text('Sales Insights'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6D9773),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sales Distribution",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                final index = value.toInt();
                                if (index >= 0 && index < shopSales.length) {
                                  return SideTitleWidget(
                                    axisSide: AxisSide.bottom,
                                    child: Text(
                                      shopSales[index]['shop'].toString().split(' ').first,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: const Color(0xFF6D9773),
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: true, color: const Color(0xFF6D9773).withOpacity(0.2)),
                            spots: List.generate(shopSales.length, (index) {
                              return FlSpot(index.toDouble(), (shopSales[index]['sales'] as int).toDouble());
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Top Selling Items",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: shopSales.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final shop = shopSales[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_florist, color: Color(0xFF6D9773), size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shop['shop'],
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("Sales: ${shop['sales']}", style: const TextStyle(color: Colors.black87)),
                                  Text("Top Item: ${shop['topItem']}", style: const TextStyle(color: Colors.black54)),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
