// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:e2e/e2e.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getTemporaryDirectory', (WidgetTester tester) async {
    final Directory result = await getTemporaryDirectory();
    _verifySampleFile(result, 'temporaryDirectory');
  });

  testWidgets('getApplicationDocumentsDirectory', (WidgetTester tester) async {
    final Directory result = await getApplicationDocumentsDirectory();
    _verifySampleFile(result, 'applicationDocuments');
  });

  testWidgets('getApplicationSupportDirectory', (WidgetTester tester) async {
    final Directory result = await getApplicationSupportDirectory();
    _verifySampleFile(result, 'applicationSupport');
  });

  testWidgets('getLibraryDirectory', (WidgetTester tester) async {
    if (Platform.isIOS) {
      final Directory result = await getLibraryDirectory();
      _verifySampleFile(result, 'library');
    } else if (Platform.isAndroid) {
      final Future<Directory> result = getLibraryDirectory();
      expect(result, throwsA(isInstanceOf<UnsupportedError>()));
    }
  });
}

/// Verify a file called [name] in [directory] by recreating it with test
/// contents when necessary.
void _verifySampleFile(Directory directory, String name) {
  final File file = File('${directory.path}/$name');

  if (file.existsSync()) {
    file.deleteSync();
    expect(file.existsSync(), isFalse);
  }

  file.writeAsStringSync('Hello world!');
  expect(file.readAsStringSync(), 'Hello world!');
  expect(directory.listSync(), isNotEmpty);
  file.deleteSync();
}
