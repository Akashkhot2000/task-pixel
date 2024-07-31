import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:task/models/users_%20model.dart';

Future<UserModels?> fetchUserData2(int limit, int skip) async {
  try {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }

    final Uri uri = Uri.parse('https://dummyjson.com/users')
        .replace(queryParameters: {'limit': '$limit', 'skip': '$skip'});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      final jsonData = json.decode(response.body);
      return UserModels.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user data: ${response.reasonPhrase}');
    }
  } on FormatException catch (e) {
    log('Error parsing response JSON: $e');
    throw Exception('Failed to parse user data');
  } on SocketException catch (e) {
    log('Network error: $e');
    throw Exception('Network error');
  } catch (e) {
    log('Unexpected error: $e');
    throw Exception('Unexpected error occurred');
  }
}



