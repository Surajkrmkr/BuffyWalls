import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';

class ProDialog {
  static const bool appIsPro = true;

  static final List<String> proTip = [
    "All Premium Walls access",
    "Accent color Feature Unlocked",
    "Premium Amoled Mode Unlocked",
    "Get rid of ADS for lifetime",
    "Add Favourite Walls for own collection"
  ];

  static Widget getCrown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            "assets/Pro Dialog/crown.png",
            height: 30,
          )),
    );
  }

  static List<Widget> pages(BuildContext context) => List.generate(
        5,
        (index) => Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 200,
                child: Image.asset(
                  "assets/Pro Dialog/${index + 1}.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              proTip[index],
              textAlign: TextAlign.center,
              style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
