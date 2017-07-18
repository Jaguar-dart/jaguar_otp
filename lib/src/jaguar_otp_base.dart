// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:math';
import 'package:base32/base32.dart';
import "dart:typed_data";
import 'package:crypto/crypto.dart';

/// Enumeration for algorithm parameter in OTP key Uri
class TotpAlgorithm {
  final int id;

  final String name;

  const TotpAlgorithm._(this.id, this.name);

  static const TotpAlgorithm sha1 = const TotpAlgorithm._(0, 'SHA1');

  static const TotpAlgorithm sha256 = const TotpAlgorithm._(0, 'SHA256');

  static const TotpAlgorithm sha512 = const TotpAlgorithm._(0, 'SHA512');
}

/// Enumeration for digits parameter in OTP key Uri
class TotpDigits {
  final int id;

  final int digits;

  const TotpDigits._(this.id, this.digits);

  static const TotpDigits six = const TotpDigits._(0, 6);

  static const TotpDigits eight = const TotpDigits._(0, 8);
}

/// Namespace for TOTP functions
class Totp {
  /// Makes TOTP Uri from its components
  static String makeUri(String issuer, String accountName, String secret,
      {TotpAlgorithm algorithm, TotpDigits digits, int period}) {
    final sb = new StringBuffer();

    sb.write('otpauth://totp/');
    sb.write(Uri.encodeComponent(issuer));
    sb.write(':');
    sb.write(Uri.encodeComponent(accountName));

    // Write secret parameter
    sb.write('?secret=');
    sb.write(secret);

    // Write issuer parameter
    sb.write('&issuer=');
    sb.write(Uri.encodeComponent(issuer));

    // Write algorithm parameter
    if (algorithm != null && algorithm != TotpAlgorithm.sha1) {
      sb.write('&algorithm=');
      sb.write(algorithm.name);
    }

    // Write digits parameter
    if (digits != null && digits != TotpDigits.six) {
      sb.write('&digits=');
      sb.write(digits.digits);
    }

    // Write period parameter
    if (period != null && period != 30) {
      sb.write('&period=');
      sb.write(period);
    }

    return sb.toString();
  }

  /// Generates a random secret for use with TOTP
  static String generateSecret() {
    final rand = new Random.secure();
    final bytes = <int>[];

    for (int i = 0; i < 10; i++) {
      bytes.add(rand.nextInt(256));
    }

    return base32.encode(bytes);
  }

  /// Generates a new TOTP code for given secret and time
  static int generateCode(String secret,
      {DateTime time, TotpDigits digits: TotpDigits.six, int period: 30}) {
    if (time == null) time = new DateTime.now();
    final int periods = time.millisecondsSinceEpoch ~/ (1000 * period);
    return _generateCode(secret, periods, digits.digits);
  }

  static int _generateCode(String secret, int time, int length) {
    final Uint8List secretList = base32.decode(secret);
    final List<int> timebytes = _int2bytes(time);

    final hmac = new Hmac(sha1, secretList);
    final List<int> hash = hmac.convert(timebytes).bytes;

    final int offset = hash[hash.length - 1] & 0xf;

    final int binary = ((hash[offset] & 0x7f) << 24) |
        ((hash[offset + 1] & 0xff) << 16) |
        ((hash[offset + 2] & 0xff) << 8) |
        (hash[offset + 3] & 0xff);

    return binary % pow(10, length);
  }

  static List<int> _int2bytes(int long) {
// we want to represent the input as a 8-bytes array
    var byteArray = [0, 0, 0, 0, 0, 0, 0, 0];
    for (var index = byteArray.length - 1; index >= 0; index--) {
      var byte = long & 0xff;
      byteArray[index] = byte;
      long = (long - byte) ~/ 256;
    }
    return byteArray;
  }
}
