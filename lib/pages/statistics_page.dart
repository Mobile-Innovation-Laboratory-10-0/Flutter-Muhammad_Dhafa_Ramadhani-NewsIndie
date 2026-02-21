import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/statistics_controller.dart';
import '../utils/constants.dart';

class StatisticsPage extends StatelessWidget {
  StatisticsPage({super.key});

  final StatisticsController statsController = Get.put(StatisticsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'STATISTIK',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            letterSpacing: 2,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          statsController.refreshStatistics();
        },
        color: AppColors.black,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewSection(),
              const SizedBox(height: 24),
              _buildActivityChart(),
              const SizedBox(height: 24),
              _buildCategorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Aktivitas',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.open_in_new,
                    label: 'Total Buka App',
                    value: statsController.totalAppOpens.value.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.article,
                    label: 'Artikel Dibaca',
                    value: statsController.totalArticlesRead.value.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.bookmark,
                    label: 'Total Bookmark',
                    value: statsController.totalBookmarks.value.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_today,
                    label: 'Hari Aktif',
                    value: '${statsController.daysActive.value} hari',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              icon: Icons.favorite,
              label: 'Kategori Favorit',
              value: statsController.favoriteCategory.value,
              fullWidth: true,
            ),
          ],
        ));
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [newspaperShadow],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.gray),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              fontSize: fullWidth ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    return Obx(() {
      final usageData = statsController.last7DaysUsage;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [newspaperShadow],
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktivitas 7 Hari Terakhir',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(usageData),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < usageData.length) {
                            final date = usageData[value.toInt()].date;
                            final weekday = [
                              'Min',
                              'Sen',
                              'Sel',
                              'Rab',
                              'Kam',
                              'Jum',
                              'Sab'
                            ][date.weekday % 7];
                            return Text(
                              weekday,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppColors.gray,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.gray,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.silver,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: List.generate(
                    usageData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: usageData[index].articlesRead.toDouble(),
                          color: AppColors.black,
                          width: 16,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(2)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Artikel dibaca per hari',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.gray,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  double _getMaxY(List usageData) {
    if (usageData.isEmpty) return 10;
    final maxReads =
        usageData.map((u) => u.articlesRead).reduce((a, b) => a > b ? a : b);
    return (maxReads + 2).toDouble();
  }

  Widget _buildCategorySection() {
    return Obx(() {
      final breakdown = statsController.categoryBreakdown;

      if (breakdown.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [newspaperShadow],
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.pie_chart, size: 48, color: AppColors.silver),
                const SizedBox(height: 12),
                Text(
                  'Belum ada data kategori',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Sort by count descending
      final sortedEntries = breakdown.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final total = breakdown.values.reduce((a, b) => a + b);

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [newspaperShadow],
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori yang Dibaca',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            ...sortedEntries.map((entry) {
              final percentage = (entry.value / total * 100).toStringAsFixed(0);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          '$percentage% (${entry.value}x)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: entry.value / total,
                        backgroundColor: AppColors.silver,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.black),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}
