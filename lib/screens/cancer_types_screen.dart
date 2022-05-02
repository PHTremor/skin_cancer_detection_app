import 'package:flutter/material.dart';
import 'package:skin_cancer_detector/components/app_bar.dart';
import 'package:skin_cancer_detector/enums/cancer_types.dart';

import '../components/reausable_widget.dart';

class CancerTypesScreen extends StatelessWidget {
  const CancerTypesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          height: 150,
          title: "Cancer Types",
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: cancerTYpes.length,
          itemBuilder: (BuildContext context, int index) {
            // Render our item
            return _buildExpandableTile(cancerTYpes[index]);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }

  Widget _buildExpandableTile(cancerTYp) {
    return ExpansionTile(
      title: Text(
        cancerTYp['name'],
      ),
      children: [
        ListTile(
          title: Text(
            cancerTYp['description'],
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        ExpansionTile(
          backgroundColor: Colors.purple.withOpacity(0.4),
          title: const Text("Signs & Symptoms"),
          children: [getTextWidget(cancerTYp['signs'])],
        )
      ],
    );
  }
}
