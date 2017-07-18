// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_otp/jaguar_otp.dart';
import 'package:test/test.dart';

const secret1 = 'VULIQLJNTDR3CIPY';

void main() {
  group('TOTP', () {
    setUp(() {});

    test('Make URI', () async {
      String uri = Totp.makeUri('teja', 'tejainece@gmail.com', secret1);
      expect(uri,
          'otpauth://totp/teja:tejainece%40gmail.com?secret=VULIQLJNTDR3CIPY&issuer=teja');
    });

    test('Generate code', () async {
      final time = DateTime.parse('2017-07-18 02:23:53.011777');
      expect(Totp.generateCode(secret1, time: time), 160576);
    });
  });
}
