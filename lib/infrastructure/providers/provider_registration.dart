import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpracticaldemo/infrastructure/providers/home_provider.dart';

final homeProvider = ChangeNotifierProvider((ref) => HomeProvider());
