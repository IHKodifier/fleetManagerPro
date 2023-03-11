// Widget build(BuildContext context) {
   
//     return  Scaffold(
//       body: Center(
//         // color: Colors.yellow,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment. stretch,
//           children: [
//             const Spacer(flex: 3,),
//             ElevatedButton.icon(onPressed: onLoginPressed, icon: const Icon(Icons.login), label: const Text('Login')),
//             const Spacer(),
//             TextButton.icon(onPressed: onLogOutPressed, icon: const Icon(Icons.logout), label: const Text('Log out')),
//             const Spacer(flex:3),
         
//           ],
//         )),
//     );
//   }

//   void onLoginPressed() {
//     FirebaseAuth.instance.signInWithEmailAndPassword(email: 's@d.com', password: '123456');
//   }

//   void onLogOutPressed() {
//   }
  
  
  
  

  

//   ///LOGIN SCREEN 
  
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('you have logged in'),
//             SizedBox(
//               height: 60, 
//               width: double.infinity,
//               child: ElevatedButton.icon(onPressed: onLogoutPressed, icon: const Icon(Icons.logout), label: const Text('Log out')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void onLogoutPressed() {
//     FirebaseAuth.instance.signOut();
//   }