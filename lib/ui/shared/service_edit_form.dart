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
  // ignore: library_private_types_in_public_api
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
              decoration: const InputDecoration(labelText: 'Service Name'),
            ),
            // Spacer(),
            const SizedBox(height: 8,),
            TextField(
              controller: costController,
              decoration: const InputDecoration(labelText: 'Cost'),
            ),
                        const SizedBox(height: 8,),
    
            Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8,),
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
                        for (var document in querySnapshot.docs) {
                          document.reference.update({
                            'name': nameController.text,
                            'cost': int.parse(costController.text),
                          });
                        }
                      });
                    
                      setState(() {
                        isSaving = false;
                        ref.invalidate(allServicesProvider);
                      });
                    
                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
                  ),
                ),
                ],),
                const SizedBox(height: 16,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isSaving) {
                        return;
                      }
               await  showDialog(context: context, builder: (context)=>AlertDialog(title: const Text('Delete  this service?'),
               content: const Text('Are you sure you want to delete this service?'),
               actions: [ElevatedButton(onPressed: (){Navigator.pop(context);}, child: const Text('NO , DON\'T DELETE'),
                ),
                TextButton(onPressed: (){
    FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userUUId)
                          .collection('services')
                          .where('name', isEqualTo: widget.name)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userUUId)
                              .collection('services')
                              .doc(doc.id)
                              .delete();
                        }
                      });
    
    
                }, child: const Text('Yes delete  it '),
                ),
                
               ],));
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userUUId)
                          .collection('services')
                          .where('name', isEqualTo: widget.name)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userUUId)
                              .collection('services')
                              .doc(doc.id)
                              .delete();
                        }
                      });
                
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
                ),
             
            
          ],
        ),
      ),
    );
  }
}
