import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person.dart';
import '../models/contract.dart';

class LoanProvider with ChangeNotifier {
  List<Person> _people = [];
  List<Contract> _contracts = [];

  List<Person> get people => _people;
  List<Contract> get contracts => _contracts;

  LoanProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load people
    final peopleJson = prefs.getStringList('people') ?? [];
    _people = peopleJson
        .map((json) => Person.fromMap(jsonDecode(json)))
        .toList();

    // Load contracts
    final contractsJson = prefs.getStringList('contracts') ?? [];
    _contracts = contractsJson
        .map((json) => Contract.fromMap(jsonDecode(json)))
        .toList();

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save people
    final peopleJson = _people
        .map((person) => jsonEncode(person.toMap()))
        .toList();
    await prefs.setStringList('people', peopleJson);

    // Save contracts
    final contractsJson = _contracts
        .map((contract) => jsonEncode(contract.toMap()))
        .toList();
    await prefs.setStringList('contracts', contractsJson);
  }

  // Add a new person
  Future<void> addPerson(Person person) async {
    _people.add(person);
    await _saveData();
    notifyListeners();
  }

  // Update a person
  Future<void> updatePerson(Person person) async {
    final index = _people.indexWhere((p) => p.id == person.id);
    if (index >= 0) {
      _people[index] = person;
      await _saveData();
      notifyListeners();
    }
  }

  // Delete a person
  Future<void> deletePerson(String id) async {
    _people.removeWhere((person) => person.id == id);
    await _saveData();
    notifyListeners();
  }

  // Add a new contract
  Future<void> addContract(Contract contract) async {
    _contracts.add(contract);
    await _saveData();
    notifyListeners();
  }

  // Get a person by ID
  Person? getPersonById(String id) {
    try {
      return _people.firstWhere((person) => person.id == id);
    } catch (e) {
      return null;
    }
  }

  // Mark a loan as paid
  Future<void> markAsPaid(String personId) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index >= 0) {
      final person = _people[index];
      _people[index] = person.copyWith(isPaid: true);
      await _saveData();
      notifyListeners();
    }
  }

  /// Mark a loan as unpaid. This reverses a previous payment action.
  Future<void> markAsUnpaid(String personId) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index >= 0) {
      final person = _people[index];
      final updatedPerson = person.copyWith(isPaid: false);
      _people[index] = updatedPerson;
      await _saveData();
      notifyListeners();
    }
  }
}
