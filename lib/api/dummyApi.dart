import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ostello/model/dummy_model.dart';

class Api {
  static Future<List<Dummy>> getData(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    try {
      final data = await assetBundle.loadString('assets/dummy.json');
      if (data.isNotEmpty) {
        final body = jsonDecode(data);
        return body.map<Dummy>(Dummy.fromJson).toList();
      } else {
        throw Exception('Error: Data could not be load');
      }
    } catch (e) {
      throw Exception('Error : $e');
    }
  }
}
