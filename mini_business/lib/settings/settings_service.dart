import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsService {
  static const _priceVariationsKey = 'price_variations';
  static final SettingsService _instance = SettingsService._internal();
  
  factory SettingsService() {
    return _instance;
  }
  
  SettingsService._internal();

  List<String> _priceVariationLabels = ['Retail', 'Trade', 'Wholesale'];

  List<String> get priceVariationLabels => _priceVariationLabels;

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_priceVariationsKey);
      if (raw != null) {
        _priceVariationLabels = raw;
      }
    } on MissingPluginException catch (e) {
      debugPrint('SharedPreferences plugin missing: $e');
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> savePriceVariations(List<String> labels) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_priceVariationsKey, labels);
      _priceVariationLabels = labels;
    } on MissingPluginException catch (e) {
      debugPrint('SharedPreferences plugin missing: $e');
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}
