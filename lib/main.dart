import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

class SecurePasswordGenerator {
  static const MethodChannel _channel =
      MethodChannel('secure_password_generator');

  // This method will be called from the Android side
  static Future<String> generatePassword({
    int length = 8,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecial = true,
  }) async {
    var params = PasswordGenerator.generatePassword(
      length: length,
      includeUppercase: includeUppercase,
      includeLowercase: includeLowercase,
      includeNumbers: includeNumbers,
      includeSpecial: includeSpecial,
    );

    final String password =
        await _channel.invokeMethod('generatePassword', params);
    return password;
  }
}

class PasswordGenerator {
  static String generatePassword({
    int length = 8,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecial = true,
  }) {
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String special = '!@#\$%^&*()-_+=<>?';

    String chars = '';
    if (includeUppercase) chars += uppercase;
    if (includeLowercase) chars += lowercase;
    if (includeNumbers) chars += numbers;
    if (includeSpecial) chars += special;

    if (chars.isEmpty) return '';

    return List.generate(length, (index) {
      final randomIndex = Random.secure().nextInt(chars.length);
      return chars[randomIndex];
    }).join('');
  }
}

void main() => SecurePasswordGenerator();
