import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/ui_color.dart';

class MyBlob {
  static getBlob(context) => IgnorePointer(
        child: Blob.animatedRandom(
          size: 300,
          loop: true,
          duration: const Duration(milliseconds: 1000),
          styles: BlobStyles(
            color: Provider.of<Uicolor>(context)
                .defaultAccentColor
                .withOpacity(0.1),
          ),
        ),
      );
}
