// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_otp/jaguar_otp.dart';
import 'package:jaguar_otp/src/qr.dart';

main() async {
  // Generate secret for an account
  final String secret = Totp.generateSecret();
  print('secret');

  // Create TOTP Uri
  final String uri = Totp.makeUri('teja', 'tejainece@gmail.com', secret);
  print(uri);

  // Create TOTP Uri Qr code
  final qr = new Qr(uri);
  await qr.save('qr.png');

  // Generate for present time
  print(Totp.generateCode(secret));
}
