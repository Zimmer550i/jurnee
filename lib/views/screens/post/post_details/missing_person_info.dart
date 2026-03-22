part of 'post_details.dart';

class MissingPersonInfo extends StatelessWidget {
  const MissingPersonInfo({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Missing Person’s Information',
          style: AppTexts.tmds.copyWith(color: AppColors.gray.shade700),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Name: ',
              style: AppTexts.tsms.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              post.missingName ?? '',
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Age: ',
              style: AppTexts.tsms.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              post.missingAge.toString(),
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Clothing Info: ',
              style: AppTexts.tsms.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              post.clothingDescription ?? '',
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Contact Info: ',
              style: AppTexts.tsms.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              post.contactInfo.toString(),
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
