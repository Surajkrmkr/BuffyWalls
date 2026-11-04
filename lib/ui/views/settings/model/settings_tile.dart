import 'package:flutter/material.dart' show IconData, Icons;

import '../../../../services/service_export.dart';
import '../../../common/common_export.dart';
import '../../view_export.dart';

class SettingsTile {
  final String title;
  final String description;
  final IconData? iconData;
  final String? icon;
  final Function() onTap;
  const SettingsTile(
      {required this.title,
      required this.description,
      this.iconData,
      this.icon,
      required this.onTap});
}

List<SettingsTile> settingsTopTiles(SettingsViewModel viewModel) => [
      SettingsTile(
          title: AppStrings.themeText,
          description: AppStrings.themeDescText,
          iconData: Icons.palette_outlined,
          onTap: viewModel.onThemeTileTap),
      SettingsTile(
          title: AppStrings.cacheText,
          description: AppStrings.cacheDescText,
          iconData: Icons.cleaning_services_outlined,
          onTap: viewModel.onCacheTileTap),
      SettingsTile(
          title: AppStrings.changelogText,
          description: AppStrings.changelogDescText,
          iconData: Icons.auto_awesome_outlined,
          onTap: viewModel.onChangelogTileTap),
    ];

List<SettingsTile> settingsBottomTiles(SettingsViewModel viewModel) => [
      SettingsTile(
          title: AppStrings.shareText,
          description: AppStrings.shareDescText,
          iconData: Icons.ios_share_rounded,
          onTap: viewModel.onShareTileTap),
      SettingsTile(
          title: AppStrings.rateText,
          description: AppStrings.rateDescText,
          iconData: Icons.star_outline_rounded,
          onTap: () => viewModel.onSocialTileTap(
              BuffyService.isPro ? Links.buffyPaid : Links.buffyFree)),
      SettingsTile(
          title: AppStrings.helpAndFeedbackText,
          description: AppStrings.helpAndFeedbackDescText,
          iconData: Icons.mail_outline_rounded,
          onTap: () => viewModel.onSocialTileTap(Links.gmail, isEmail: true)),
      // SettingsTile(
      //     title: AppStrings.donateText,
      //     description: AppStrings.donateDescText,
      //     icon: Svgs.donate,
      //     onTap: viewModel.onDonateTileTap),
    ];

List<SettingsTile> settingsLowerBottomTiles(SettingsViewModel viewModel) => [
      SettingsTile(
          title: AppStrings.aboutUsText,
          description: AppStrings.aboutUsDescText,
          iconData: Icons.info_outline_rounded,
          onTap: viewModel.onAboutUsTileTap),
      SettingsTile(
          title: AppStrings.privacyPolicyText,
          description: AppStrings.privacyPolicyDescText,
          iconData: Icons.shield_outlined,
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
