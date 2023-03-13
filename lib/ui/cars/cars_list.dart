import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fruitsProvider =
    StreamProvider<Stream<QuerySnapshot<Map<String, dynamic>>>>((ref) async* {
  yield FirebaseFirestore.instance.collection('fruits').snapshots();
});

class CarsListPage extends ConsumerWidget {
  const CarsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(fruitsProvider);

    return stream.when(
     error: onError, 
     loading: onLoading,
      data: onData,
     );
  }

  Widget onError(Object error, StackTrace stackTrace) {return Text(error.toString()+ stackTrace.toString());
  }

  Widget onLoading() {return CircularProgressIndicator();
  }

  Widget onData(Stream<QuerySnapshot<Map<String, dynamic>>> data) {
    return ListView(
      children: data.map((snapshot) => snapshot.docs.map((e) => ListTile(title: Text(e.data()['name']),))).toList(),
    );
  }
}
