import 'package:flutter/cupertino.dart';

class FilterData extends ChangeNotifier {
  final List<String> _categoryMenuEntries = [
    'Add New',
    'Work',
    'Home',
    'School'
  ];
  final List<String> _categoryFilters = ['All', 'Work', 'Home', 'School'];
  final List<String> _priorityFilters = ['All', 'High', 'Normal', 'Low'];

  //Selected Priorities will only ever have All, or the other priorities
  final List<String> _selectedPriorities = ['All'];
  final List<String> _selectedCategories = ['All'];

  bool allPriorities = true;
  bool allCategories = true;

  List<String> get categoryFilters => _categoryFilters;

  List<String> get priorityFilters => _priorityFilters;

  List<String> get categoryMenuEntries => _categoryMenuEntries;

  void priorityHandler(String priority) {
    if (priority != 'All') {
      if (_selectedPriorities.contains('All')) {
        _selectedPriorities.remove('All');
        _selectedPriorities.add(priority);
      } else {
        _selectedPriorities.add(priority);
        if (!_selectedPriorities.contains('All') &&
            _selectedPriorities.length == _priorityFilters.length - 1) {
          _selectedPriorities.clear();
          _selectedPriorities.add('All');
        }
      }
    } else {
      _selectedPriorities.clear();
      _selectedPriorities.add('All');
    }
    notifyListeners();
  }

  void categoryHandler(String category) {
    if (category != 'All') {
      if (_selectedCategories.contains('All')) {
        _selectedCategories.remove('All');
        _selectedCategories.add(category);
      } else {
        _selectedCategories.add(category);
        if (!_selectedCategories.contains('All') &&
            _selectedCategories.length == _categoryFilters.length - 1) {
          _selectedCategories.clear();
          _selectedCategories.add('All');
        }
      }
    } else {
      _selectedCategories.clear();
      _selectedCategories.add('All');
    }
    notifyListeners();
  }

  bool isPrioritySelected(String priority) {
    return _selectedPriorities.contains(priority);
  }

  bool isCategorySelected(String category) {
    return _selectedCategories.contains(category);
  }

  void addCategory(String newCategory) {
    if (!_categoryMenuEntries.contains(newCategory)) {
      _categoryMenuEntries.add(newCategory);
      _categoryFilters.add(newCategory);
      notifyListeners();
    }
  }
}
