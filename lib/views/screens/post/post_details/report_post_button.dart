part of 'post_details.dart';

class ReportPostButton extends StatelessWidget {
  const ReportPostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: CustomSvg(asset: 'assets/icons/options.svg'),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          backgroundColor: AppColors.scaffoldBG,
          builder: (context) {
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Text('Why you are reporting this post?', style: AppTexts.txsb),
                    const SizedBox(height: 8),
                    CustomTextField(lines: 5, hintText: 'Start writing...'),
                    const SizedBox(height: 24),
                    CustomButton(onTap: () => Get.back(), text: 'Submit'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
      menuPadding: EdgeInsets.zero,
      color: AppColors.white,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: '1',
          child: Row(
            spacing: 8,
            children: [
              Transform.translate(
                offset: Offset(0, 2),
                child: CustomSvg(asset: 'assets/icons/report.svg'),
              ),
              Text(
                'Report',
                style: AppTexts.tsms.copyWith(color: AppColors.green.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
