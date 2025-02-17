import 'package:flutter/material.dart';
import 'package:mcq_learning_app/shared_preferences/tenant_config.dart';

class TenantProvider with ChangeNotifier {
  TenantConfig? _config;

  TenantConfig? get config => _config;

  void setConfig(TenantConfig config) {
    _config = config;
    notifyListeners();
  }
}
