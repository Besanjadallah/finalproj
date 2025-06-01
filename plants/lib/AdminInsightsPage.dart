import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminInsightsPage extends StatelessWidget {
  final List<Map<String, dynamic>> shopSales = [
    {'shop': 'Green Garden', 'sales': 250, 'topItem': 'Basil Plant'},
    {'shop': 'EcoPlants', 'sales': 180, 'topItem': 'Snake Plant'},
    {'shop': 'Cactus World', 'sales': 120, 'topItem': 'Mini Cactus'},
    {'shop': 'Leafy Lane', 'sales': 90, 'topItem': 'Fern'},
    {'shop': 'Bloom Bazaar', 'sales': 210, 'topItem': 'Orchid'},
  ];

  AdminInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    int totalSales = shopSales.fold<int>(
      0,
      (sum, item) => sum + (item['sales'] as int),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        title: const Text('Sales Insights'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6D9773),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sales Distribution",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.5,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < shopSales.length) {
                            return SideTitleWidget(
                              axisSide: AxisSide.bottom,
                              space: 6,
                              child: Text(
                                shopSales[index]['shop']
                                    .toString()
                                    .split(' ')
                                    .first,
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: List.generate(shopSales.length, (index) {
                    final shop = shopSales[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (shop['sales'] as int).toDouble(),
                          color: const Color(0xFF6D9773),
                          width: 22,
                          borderRadius: BorderRadius.circular(6),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: totalSales.toDouble(),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Top Selling Items",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: shopSales.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final shop = shopSales[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.local_florist,
                        color: Color(0xFF6D9773),
                      ),
                      title: Text(
                        shop['shop'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sales: ${shop['sales']}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            "Top Item: ${shop['topItem']}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
