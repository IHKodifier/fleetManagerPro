import 'dart:io';

import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';

class mediaThumbnail extends StatelessWidget {
  const mediaThumbnail({
    super.key,
    required this.file});

final File file;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 50,
      child: Container(
        
        
        child: Image.file(
          file,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
