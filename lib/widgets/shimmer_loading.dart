import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/constants.dart';

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isCard;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.isCard = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCard) {
      return _buildCardSkeleton();
    }

    return Shimmer.fromColors(
      baseColor: AppColors.silver,
      highlightColor: AppColors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.silver,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [newspaperShadow],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.silver,
            highlightColor: AppColors.white,
            child: Container(
              height: 120,
              width: double.infinity,
              color: AppColors.silver,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.silver,
                  highlightColor: AppColors.white,
                  child: Container(
                    width: 80,
                    height: 20,
                    color: AppColors.silver,
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: AppColors.silver,
                  highlightColor: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: AppColors.silver,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: AppColors.silver,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 150,
                        height: 16,
                        color: AppColors.silver,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: AppColors.silver,
                  highlightColor: AppColors.white,
                  child: Container(
                    width: 120,
                    height: 12,
                    color: AppColors.silver,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
