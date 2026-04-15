import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedTemplateProvider = StateProvider<int>((ref) => 1);
final selectedVariantProvider = StateProvider<Color?>((ref) => null);