import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/common/dropdown.dart';
import 'package:task/provider/user_provider.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  String? _selectedCity;
  String? _selectedGender;
  List<String> _cities = [];
  List<String> _genders = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await Provider.of<UserProvider>(context, listen: false)
        .fetchAndSetUserData(limit: 10, skip: 0);
    _updateCitiesAndGenders();
  }

  void _updateCitiesAndGenders() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userModel = userProvider.user;

    if (userModel != null && userModel.users != null) {
      final uniqueCities = <String>{};
      final uniqueGenders = <String>{};

      for (var user in userModel.users!) {
        if (user.address?.city != null) {
          uniqueCities.add(user.address!.city!);
        }
        if (user.gender != null) {
          uniqueGenders.add(user.gender!);
        }
      }

      setState(() {
        _cities = uniqueCities.toList()..sort();
        _genders = uniqueGenders.toList()..sort();
      });
    }
  }

  void _nextPage() {
    Provider.of<UserProvider>(context, listen: false).fetchNextPage();
  }

  void _previousPage() {
    Provider.of<UserProvider>(context, listen: false).fetchPreviousPage();
  }

  void _resetFilter() {
    setState(() {
      _selectedCity = null;
      _selectedGender = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/pixel.jpg',
          scale: 6,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.filter_alt, color: Colors.red),
              onPressed: _resetFilter,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final userModel = userProvider.user;
            final hasUsers = userModel != null &&
                userModel.users != null &&
                userModel.users!.isNotEmpty;

            final filteredUsers = hasUsers
                ? userModel!.users!.where((user) {
                    final cityMatch = _selectedCity == null ||
                        user.address?.city == _selectedCity;
                    final genderMatch = _selectedGender == null ||
                        user.gender == _selectedGender;
                    return cityMatch && genderMatch;
                  }).toList()
                : [];

            final int startIndex = (userProvider.currentPage - 1) * 10 + 1;
            final int endIndex = startIndex + filteredUsers.length - 1;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Employees',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        CommonDropdown(
                          selectedValue: _selectedCity,
                          items: _cities,
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                          },
                          hint: 'City',
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CommonDropdown(
                          selectedValue: _selectedGender,
                          items: _genders,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          hint: 'Gender',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: hasUsers
                        ? DataTable(
                            columns: const [
                              DataColumn(
                                  label: Text('ID',
                                      style: TextStyle(fontSize: 14))),
                              DataColumn(
                                  label: Text('Image',
                                      style: TextStyle(fontSize: 14))),
                              DataColumn(
                                  label: Text('Full Name',
                                      style: TextStyle(fontSize: 14))),
                              DataColumn(
                                  label: Text('Demography',
                                      style: TextStyle(fontSize: 14))),
                              DataColumn(
                                  label: Text('Designation',
                                      style: TextStyle(fontSize: 14))),
                              DataColumn(
                                  label: Text('Location',
                                      style: TextStyle(fontSize: 14))),
                            ],
                            rows: filteredUsers.map((user) {
                              return DataRow(cells: [
                                DataCell(Text(user.id.toString(),
                                    style: const TextStyle(fontSize: 14))),
                                DataCell(user.image != null
                                    ? Image.network(user.image!,
                                        width: 24, height: 24)
                                    : const FlutterLogo(size: 24)),
                                DataCell(Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: const TextStyle(fontSize: 14))),
                                DataCell(Text('${user.age}, ${user.gender}',
                                    style: const TextStyle(fontSize: 14))),
                                DataCell(Text(user.role ?? 'Unknown',
                                    style: const TextStyle(fontSize: 14))),
                                DataCell(Text(
                                    '${user.address?.city ?? 'Unknown'}, ${user.address?.country ?? 'Unknown'}',
                                    style: const TextStyle(fontSize: 14))),
                              ]);
                            }).toList(),
                          )
                        : const Center(child: Text('No users found.')),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed:
                          userProvider.currentPage > 1 ? _previousPage : null,
                      icon: const Icon(Icons.arrow_back_ios),
                      tooltip: 'Previous Page',
                    ),
                    Text(
                      hasUsers ? '$startIndex to $endIndex' : '0 to 0',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed:
                          userProvider.hasMore && hasUsers ? _nextPage : null,
                      icon: const Icon(Icons.arrow_forward_ios),
                      tooltip: 'Next Page',
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
