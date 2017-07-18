# jaguar_otp

TOTP utilities for Dart and Jaguar.dart

# Usage

## Generate secret

`generateSecret` method on `Totp` generates a Base32 encoded secret for use with TOTP.

```dart
  // Generate secret for an account
  final String secret = Totp.generateSecret();
  print('secret');
```

## Create TOTP Uri

`makeUri` method on `Totp` creates TOTP Uri from individual components.

```dart
  // Create TOTP Uri
  String uri = Totp.makeUri('teja', 'tejainece@gmail.com', secret);
  print(uri);
```

## Generate code

```dart
  // Generate for present time
  print(Totp.generateCode(secret));
```

## Generate Qr code for TOTP Uri

```dart
  // Create TOTP Uri Qr code
  final qr = new Qr(uri);
  await qr.save('qr.png');
```
