part of 'post_details.dart';

class PostEarnings extends StatelessWidget {
  const PostEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gray.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CustomSvg(asset: 'assets/icons/booking.svg', size: 20),
                  Text('Booking', style: AppTexts.tmdr),
                  Text('6', style: AppTexts.tmdb),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gray.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CustomSvg(asset: 'assets/icons/unit_price.svg', size: 20),
                  Text('Unit Price', style: AppTexts.tmdr),
                  Text('\$66', style: AppTexts.tmdb),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gray.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CustomSvg(asset: 'assets/icons/earning.svg', size: 20),
                  Text('Earning', style: AppTexts.tmdr),
                  Text('\$120', style: AppTexts.tmdb),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
