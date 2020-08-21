class Item {
  final String documentID;
  final String userUID;
  final String name;
  final int quantity;
  final double price;
  final String description;
  final String address;

  // if item is for rent
  final bool forRent;

  // if items are placed by farmer 
  final bool forBid;
  final List<dynamic> bidders;
  final List<dynamic> bidPrice;
  final int bidAcceptIndex;
  
  // TimeStamps
  final int originTimeStamp;
  final int bidEndTimeStamp;
  final int deleteTimeStamp;

  // To store distance from querying/current user
  double distanceFromCurrentUser;

  Item({this.documentID, this.userUID, this.name, this.quantity, this.price,
        this.description, this.address, this.forRent, this.distanceFromCurrentUser,
        this.forBid, this.bidders, this.bidPrice, this.bidAcceptIndex,
        this.originTimeStamp, this.bidEndTimeStamp, this.deleteTimeStamp});
}