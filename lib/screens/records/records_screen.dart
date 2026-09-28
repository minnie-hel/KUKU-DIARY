import 'package:flutter/material.dart';

import '../farm_management/farm_management_screen.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FarmManagementScreen(nested: true);
  }
}
