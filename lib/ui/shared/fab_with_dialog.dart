
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';
import 'package:flutter/material.dart';

import '../screens/add_maintenance_screen.dart';




class FabWithDialog extends StatefulWidget {
  final IconData icon;
  final String label;

  FabWithDialog({required this.icon, required this.label});

  @override
  _FabWithDialogState createState() => _FabWithDialogState();
}

class _FabWithDialogState extends State<FabWithDialog> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            physics: BouncingScrollPhysics(),
            children: [
              Text('Select Maintenance Type',style: Theme.of(context).textTheme.headlineSmall,),
          SizedBox(height: 12),
              _buildDialogButton(context, "Regular Scheduled Maintenace "),
              // _buildDialogButton(context, "Regular Unscheduled"),
              _buildDialogButton(context, "One-Off"),
              _buildDialogButton(context, "Engne TuneUp_ECM Callibration"),
              _buildDialogButton(context, "Body Works"),
              _buildDialogButton(context, "Repairs"),
              _buildDialogButton(context, "Polish Detailing"),
              _buildDialogButton(context, "Other"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogButton(BuildContext context, String label) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom:8.0),
        child: ElevatedButton(
          onPressed: () =>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>  const AddMaintenanceScreen())),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showBottomSheet(context),
      icon: Icon(widget.icon),
      label: Text(widget.label),
    );
  }
}
