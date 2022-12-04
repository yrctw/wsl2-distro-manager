// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wsl2distromanager/api/docker_images.dart';
import 'package:wsl2distromanager/components/helpers.dart';
import 'package:wsl2distromanager/components/notify.dart';

void main() {
  void statusMsg(
    String msg, {
    bool loading = false,
    bool useWidget = false,
    bool leadingIcon = true,
    dynamic widget,
  }) {}

  // Stuff before tests
  setUpAll(() async {
    await initPrefs();

    Notify();
    Notify.message = statusMsg;
  });

  test('Docker rootfs download test', () async {
    const String image = 'library/alpine';
    const String tag = 'latest';
    const String distroPath = 'C:/WSL2-Distros/distros';
    final String filename = DockerImage().filename(image, tag);
    // Get rootfs
    await DockerImage().getRootfs(image, tag: tag,
        progress: ((count, total, countStep, totalStep) {
      if (kDebugMode) {
        print('Downloading $count/$total ($countStep/$totalStep)');
      }
    }));
    final file = File('$distroPath/$filename.tar.gz');

    // Verify that the file exists and has > 2MB
    expect(await file.exists(), true);
    expect(await file.length(), greaterThan(2 * 1024 * 1024));
  });
}
