import 'package:flutter/material.dart';
import 'package:task/features/screens/services/user_services.dart';
import 'package:task/models/users_%20model.dart';

class UserProvider extends ChangeNotifier {
  UserModels? _userModel;
  int _currentPage = 1;
  final int _usersPerPage = 10;
  bool _hasMore = true;
  String? _selectedCity;

  UserModels? get user => _userModel;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  String? get selectedCity => _selectedCity;

  void setUser(UserModels userModel) {
    _userModel = userModel;
    _hasMore = userModel.users!.length >= _usersPerPage;
    notifyListeners();
  }

  Future<void> fetchAndSetUserData(
      {required int limit, required int skip}) async {
    try {
      final userModel = await fetchUserData2(limit, skip);
      if (userModel != null) {
        setUser(userModel);
      }
    } catch (error) {
      // Log the error or use a logging service
      print('Failed to fetch user data: $error');
      // Optionally, handle the error more gracefully here
    }
  }

  Future<void> fetchNextPage() async {
    if (_hasMore) {
      await fetchAndSetUserData(
          limit: _usersPerPage, skip: _currentPage * _usersPerPage);
      _currentPage++;
    }
  }

  Future<void> fetchPreviousPage() async {
    if (_currentPage > 1) {
      _currentPage--;
      await fetchAndSetUserData(
          limit: _usersPerPage, skip: (_currentPage - 1) * _usersPerPage);
    }
  }

  void setSelectedCity(String? value) {
    _selectedCity = value;
    notifyListeners();
  }
}
