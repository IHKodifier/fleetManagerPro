
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';





class FabWithDialog extends StatefulWidget {
  final IconData icon;
  final String label;

  const FabWithDialog({super.key, required this.icon, required this.label});

  @override
  // ignore: library_private_types_in_public_api
  _FabWithDialogState createState() => _FabWithDialogState();
}

class _FabWithDialogState extends State<FabWithDialog> {


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: ()  =>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>  const AddMaintenanceScreen())),
      icon: Icon(widget.icon),
      label: Text(widget.label),
    );
  }
}
