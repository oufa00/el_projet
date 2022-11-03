// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:el_project/model/utilisateur_model.dart';
// import 'package:firebase_chat_example/model/message.dart';
//
//
// import '../model/message.dart';
// import '../utils.dart';
//
// class FirebaseApi {
//   static Stream<List<UtilisateurModel>> getUsers() => FirebaseFirestore.instance
//       .collection('users')
//       .snapshots()
//       .transform(Utils.transformer(UtilisateurModel.fromJson));
//
//   static Future uploadMessage(String idUser, String message) async {
//     final refMessages =
//     FirebaseFirestore.instance.collection('chats/$idUser/messages');
//
//     final newMessage = Message(
//       idUser: '',
//       urlAvatar: '',
//       username: '',
//       message: message,
//       createdAt: DateTime.now(),
//     );
//     await refMessages.add(newMessage.toJson());
//
//     final refUsers = FirebaseFirestore.instance.collection('users');
//     await refUsers
//         .doc(idUser)
//         .update({UserField.lastMessageTime: DateTime.now()});
//   }
//
//   static Stream<List<Message>> getMessages(String idUser) =>
//       FirebaseFirestore.instance
//           .collection('chats/$idUser/messages')
//           .orderBy(MessageField.createdAt, descending: true)
//           .snapshots()
//           .transform(Utils.transformer(Message.fromJson));
//
