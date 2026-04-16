import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Currently selected template ID (1-5)
final selectedTemplateProvider = StateProvider<int>((ref) => 1);