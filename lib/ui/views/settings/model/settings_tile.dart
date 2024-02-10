import '../../../../services/service_export.dart';
import '../../../common/common_export.dart';
import '../../view_export.dart';

class SettingsTile {
  final String title;
  final String description;
  final String icon;
  final Function() onTap;
  const SettingsTile(
      {required this.title,
      required this.description,
      required this.icon,
      required this.onTap});
}

List<SettingsTile> settingsTopTiles(SettingsViewModel viewModel) => [
      SettingsTile(
          title: AppStrings.themeText,
          description: AppStrings.themeDescText,
          icon: Svgs.theme,
          onTap: viewModel.onThemeTileTap),
      SettingsTile(
          title: AppStrings.cacheText,
          description: AppStrings.cacheDescText,
          icon: Svgs.cache,
          onTap: viewModel.onCacheTileTap),
      SettingsTile(
          title: AppStrings.changelogText,
          description: AppStrings.changelogDescText,
          icon: Svgs.changelog,
          onTap: viewModel.onChangelogTileTap),
    ];

List<SettingsTile> settingsBottomTiles(SettingsViewModel viewModel) => [
      SettingsTile(
          title: AppStrings.shareText,
          description: AppStrings.shareDescText,
          icon: Svgs.share,
          onTap: viewModel.onShareTileTap),
      SettingsTile(
          title: AppStrings.rateText,
          description: AppStrings.rateDescText,
          icon: Svgs.rate,
          onTap: () => viewModel.onSocialTileTap(
              BuffyService.isPro ? Links.buffyPaid : Links.buffyFree)),
      SettingsTile(
          title: AppStrings.helpAndFeedbackText,
          description: AppStrings.helpAndFeedbackDescText,
          icon: Svgs.help,
          onTap: () => viewModel.onSocialTileTap(Links.gmail, isEmail: true)),
      SettingsTile(
          title: AppStrings.donateText,
          description: AppStrings.donateDescText,
          icon: Svgs.donate,
          onTap: viewModel.onDonateTileTap),
    ];

List<SettingsTile> settingsLowerBottomTiles(SettingsViewModel viewModel) => [
      SettingsTile(
          title: AppStrings.aboutUsText,
          description: AppStrings.aboutUsDescText,
          icon: Svgs.about,
          onTap: viewModel.onAboutUsTileTap),
      SettingsTile(
          title: AppStrings.privacyPolicyText,
          description: AppStrings.privacyPolicyDescText,
          icon: Svgs.privacy,
          onTap: () => viewModel.onSocialTileTap(Links.privacyPolicy)),
    ];

List<SettingsTile> settingsSocialTiles(SettingsViewModel viewModel) => [
      SettingsTile(
          title: AppStrings.instagramText,
          description: AppStrings.instagramDescText,
          icon: Svgs.instagram,
          onTap: () => viewModel.onSocialTileTap(Links.instagram)),
      SettingsTile(
          title: AppStrings.twitterText,
          description: AppStrings.twitterDescText,
          icon: Svgs.twitter,
          onTap: () => viewModel.onSocialTileTap(Links.twitter)),
      SettingsTile(
          title: AppStrings.telegramText,
          description: AppStrings.telegramDescText,
          icon: Svgs.telegram,
          onTap: () => viewModel.onSocialTileTap(Links.telegram))
    ];
