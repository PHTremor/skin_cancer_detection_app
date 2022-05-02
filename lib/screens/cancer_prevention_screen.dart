import 'package:flutter/material.dart';
import 'package:skin_cancer_detector/components/reausable_widget.dart';
import 'package:skin_cancer_detector/enums/prevention_list.dart';

import '../components/app_bar.dart';

class CancerPrevention extends StatelessWidget {
  const CancerPrevention({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          height: 150,
          title: "Cancer Prevention",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [getTextWidget(prevention.toList())],
          ),
        ),
      ),
    );
  }
}
