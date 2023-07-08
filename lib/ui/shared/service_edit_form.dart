import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/service_selection_state.dart';

class ServiceEditForm extends ConsumerStatefulWidget {
  const ServiceEditForm(
      {Key? key,
      required this.name,
      required this.cost,
      required this.userUUId})
      : super(key: key);

  final int cost;
  final String name;
  final String userUUId;

  @override
  _ServiceEditFormState createState() => _ServiceEditFormState();
}

class _ServiceEditFormState extends ConsumerState<ServiceEditForm> {
  final TextEditingController costController = TextEditingController();
  bool isSaving = false;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    costController.text = widget.cost.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.infinity-10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            // Spacer(),
            SizedBox(height: 8,),
            TextField(
              controller: costController,
              decoration: InputDecoration(labelText: 'Cost'),
            ),
                        SizedBox(height: 8,),
    
            Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isSaving) {
                        return;
                      }
                    
                      setState(() {
                        isSaving = true;
                      });
                    
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userUUId)
                          .collection('services')
                          .where('name', isEqualTo: widget.name)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((document) {
                          document.reference.update({
                            'name': nameController.text,
                            'cost': int.parse(costController.text),
                          });
                        });
                      });
                    
                      setState(() {
                        isSaving = false;
                        ref.invalidate(allServicesProvider);
                      });
                    
                      Navigator.pop(context);
                    },
                    child: Text('Update'),
                  ),
                ),
                ],),
                SizedBox(height: 16,),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isSaving) {
                        return;
                      }
               await  showDialog(context: context, builder: (context)=>AlertDialog(title: Text('Delete  this service?'),
               content: Text('Are you sure you want to delete this service?'),
               actions: [ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('NO , DON\'T DELETE'),
                ),
                TextButton(onPressed: (){
    FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userUUId)
                          .collection('services')
                          .where('name', isEqualTo: widget.name)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userUUId)
                              .collection('services')
                              .doc(doc.id)
                              .delete();
                        });
                      });
    
    
                }, child: Text('Yes delete  it '),
                ),
                
               ],));
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userUUId)
                          .collection('services')
                          .where('name', isEqualTo: widget.name)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userUUId)
                              .collection('services')
                              .doc(doc.id)
                              .delete();
                        });
                      });
                
                      Navigator.pop(context);
                    },
                    child: Text('Delete'),
                  ),
                ),
             
            
          ],
        ),
      ),
    );
  }
}
