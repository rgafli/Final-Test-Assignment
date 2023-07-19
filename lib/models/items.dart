class Items {
  String? itemsId;
  String? userId;
  String? itemsName;
  String? itemsQty;
  String? itemsDesc;
  String? itemsLat;
  String? itemsLong;
  String? itemsState;
  String? itemsLocality;
  String? itemsDate;

  Items({
    this.itemsId,
    this.userId,
    this.itemsName,
    this.itemsQty,
    this.itemsDesc,
    this.itemsLat,
    this.itemsLong,
    this.itemsState,
    this.itemsLocality,
    this.itemsDate,
  });

  Items.fromJson(Map<String, dynamic> json) {
    itemsId = json['item_id'];
    userId = json['user_id'];
    itemsName = json['item_name'];
    itemsQty = json['item_qty'];
    itemsDesc = json['item_desc'];
    itemsLat = json['item_lat'];
    itemsLong = json['item_long'];
    itemsState = json['item_state'];
    itemsLocality = json['item_locality'];
    itemsDate = json['item_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemsId;
    data['user_id'] = userId;
    data['item_name'] = itemsName;
    data['item_qty'] = itemsQty;
    data['item_desc'] = itemsDesc;
    data['item_lat'] = itemsLat;
    data['item_long'] = itemsLong;
    data['item_state'] = itemsState;
    data['item_locality'] = itemsLocality;
    data['item_date'] = itemsDate;
    return data;
  }
}
