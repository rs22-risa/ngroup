import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/adaptive.dart';
import '../group/group_controller.dart';
import 'prefs_tile.dart';
import 'prefs_value.dart';
import 'settings.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  static var path = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: AdaptivePageView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrefsGroupTile(
              children: [
                PrefsEnumTile(Settings.theme),
                if (Adaptive.isDesktop) PrefsBoolTile(Settings.customFrame),
                if (!Adaptive.isDesktop || Adaptive.forceMobile)
                  PrefsBoolTile(Settings.twoPane),
                PrefsIntTile(Settings.contentScale),
              ],
            ),
            PrefsGroupTile(children: [
              PrefsIdentitiesTile(
                Settings.identities,
                onRemoved: ref.read(groupDataProvider.notifier).identityRemoved,
              ),
            ]),
            PrefsStripTile(
              Settings.stripText,
              children: [
                PrefsPatternsTile(Settings.stripSignature),
                PrefsBoolTile(Settings.stripQuote),
                PrefsBoolTile(Settings.stripSameContent),
                PrefsBoolTile(Settings.stripMultiEmptyLine),
                PrefsBoolTile(Settings.stripUnicodeEmojiModifier),
                PrefsPatternsTile(Settings.stripCustomPattern),
              ],
            ),
            PrefsGroupTile(children: [
              PrefsEnumTile(Settings.sortMode),
              PrefsEnumTile(Settings.showQuote),
              PrefsBoolTile(Settings.shortReply),
              PrefsIntTile(Settings.shortReplySize),
              PrefsBoolTile(Settings.linkPreview),
              PrefsBoolTile(Settings.smallPreview),
            ]),
            PrefsGroupTile(children: [
              PrefsIntTile(Settings.attachmentSize),
              PrefsIntTile(Settings.hideText),
              PrefsIntTile(Settings.chopQuote),
            ]),
            PrefsGroupTile(children: [
              PrefsBoolTile(Settings.unreadOnNext),
              PrefsBoolTile(Settings.threadOnNext),
              PrefsEnumTile(Settings.nextThreadMode),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class PrefsStripTile extends HookWidget {
  const PrefsStripTile(
    this.value, {
    super.key,
    this.onChanged,
    required this.children,
  });

  final PrefsValue<bool> value;
  final Function(bool)? onChanged;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    useListenable(value);
    return Card(
        child: ExpansionTile(
            title: Text(value.description!),
            trailing:
                Checkbox(value: value.val, onChanged: (v) => value.val = v!),
            controlAffinity: ListTileControlAffinity.leading,
            children: [
          ...children
              .map((e) => [const Divider(indent: 16, endIndent: 16), e])
              .expand((e) => e)
        ]));
  }
}
