import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';

class DatabaseServices {
  final String uid;
  DatabaseServices({ this.uid });
  final CollectionReference usersCollection = Firestore.instance.collection('databaseServicesUsersInformation');
  final CollectionReference itemsCollection = Firestore.instance.collection('databaseServicesItemsInformation');

  // Initiated at Registration & Edit Time to update User Data
  Future updateUserData(String name, String contactNo, bool isRetailer, String preferredLanguage, String address, bool isRegistrationComplete) async {
    return await usersCollection.document(uid).setData({
      'name': name,
      'contactNo': contactNo,
      'isRetailer': isRetailer,
      'preferredLanguage': preferredLanguage,
      'address': address,
      'isRegistrationComplete': isRegistrationComplete,
    });
  }

  // User data from snapshot
  CurrentUserData _currentUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return CurrentUserData(
      uid: uid,
      name: snapshot.data['name'],
      contactNo: snapshot.data['contactNo'],
      isRetailer: snapshot.data['isRetailer'],
      address: snapshot.data['address'],
      preferredLanguage: snapshot.data['preferredLanguage'],
      isRegistrationComplete: snapshot.data['isRegistrationComplete'],

    );
  }

  // Get User Doc Stream
  Stream<CurrentUserData> get userData {
    return usersCollection.document(uid).snapshots()
      .map(_currentUserDataFromSnapshot);
  }


// Add items in collection
  Future setItemData(String name, int quantity, double price, String description,
                      String address, bool forRent, bool forBid, int originTimeStamp,
                      int bidEndTimeStamp, int deleteTimeStamp) async {
    String docID = uid + '#' + name;
    return await itemsCollection.document(docID).setData({
      'docID': docID,
      'userUID': uid,
      'name': name,
      'quantity': quantity,
      'price': price,
      'description': description,
      'address': address,
      'forRent': forRent,
      'forBid': forBid,
      'originTimeStamp' : originTimeStamp,
      'bidEndTimeStamp' : bidEndTimeStamp,
      'deleteTimeStamp' : deleteTimeStamp,
    });
  }

  Future updateBids(String docID, List<dynamic> bidders, List<dynamic> bidPrice) async {
    return await itemsCollection.document(docID).setData({
      'bidders': bidders,
      'bidPrice' : bidPrice,
    }, merge: true);
  }

  Future acceptBid(String docID, int index) async {
    return await itemsCollection.document(docID).setData({'bidAcceptIndex' : index}, merge: true);
  }


  Future deleteItem(String itemUid) async {
    try {
      await itemsCollection.document(itemUid).delete();
      return 'Success';
    }
    catch(error) {
      print(error.toString());
      return null;
    }
  }
  // Current User item data from snapshot
  List<Item> _currentUserItemsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Item(
        documentID: doc.data['docID'],
        userUID: doc.data['userUID'],
        name: doc.data['name'],
        quantity: doc.data['quantity'],
        price: double.parse(doc.data['price'].toString()),
        description: doc.data['description'],
        address: doc.data['address'],
        forRent: doc.data['forRent'],
        forBid: doc.data['forBid'],
        bidders: doc.data['bidders'] ?? [],
        bidPrice: doc.data['bidPrice'] ?? [],
        bidAcceptIndex: doc.data['bidAcceptIndex'] ?? -1,
        distanceFromCurrentUser : -1,

        originTimeStamp: doc.data['originTimeStamp'],
        bidEndTimeStamp: doc.data['bidEndTimeStamp'],
        deleteTimeStamp: doc.data['deleteTimeStamp'],
      );
    }).toList();
  }

  // Get Current User Items Stream
  Stream<List<Item>> get currentUserItems {
    return itemsCollection.where('uid', isEqualTo: this.uid).snapshots()
      .map(_currentUserItemsFromSnapshot);
  }

  // Get Any User Information
  Future getAnyUserInfo(String uid) async{
    DocumentSnapshot userDocument = await usersCollection.document(uid).get();
    return userDocument;
  }

  Future<bool> addChatRoom (String chatRoomID, List<String> users, String itemUID, String usernames) async {
    try{
      List<dynamic> items = [];
      DocumentReference docRef = Firestore.instance.collection("ChatRoom").document(chatRoomID);
      await docRef.get()
        .then((docSnapshot) => { 
          if(docSnapshot.exists) {
            items = docSnapshot.data['items'],
          }
        });
      if(!items.contains(itemUID)) {
        items.add(itemUID);
      }  
      await Firestore.instance
            .collection("ChatRoom")
            .document(chatRoomID)
            .setData({
              'users': users,
              'chatRoomID': chatRoomID,
              'items': items,
              'usernames' : usernames,
            });
        return true;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> addMessage(String chatRoomID, chatMessageData){
    Firestore.instance.collection("ChatRoom")
      .document(chatRoomID)
      .collection("chats")
      .add(chatMessageData).catchError((e){
        print(e.toString());
    });
  }

  Future<void> addItemToChatRoom(String chatRoomID, String itemUID){
    Firestore.instance.collection("ChatRoom")
      .document(chatRoomID)
      .collection("chats")
      .add({'items' : itemUID}).catchError((e){
        print(e.toString());
    });
  }

  getChats(String chatRoomID) async{
    return Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomID)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

   getUserChats(String uid) async {
    return Firestore.instance
        .collection("ChatRoom")
        .where('users', arrayContains: uid)
        .snapshots();
  }
}