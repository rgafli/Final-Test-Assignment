// ignore_for_file: unnecessary_getters_setters

class Order {
  String? _orderId;
  String? _buyerId;
  String? _sellerId;
  String? _buyerItemId;
  String? _sellerItemId;
  String? _orderStatus;
  String? _buyerName;
  String? _sellerName;

  Order(
      {String? orderId,
      String? buyerId,
      String? sellerId,
      String? buyerItemId,
      String? sellerItemId,
      String? orderStatus,
      String? buyerName,
      String? sellerName}) {
    if (orderId != null) {
      _orderId = orderId;
    }
    if (buyerId != null) {
      _buyerId = buyerId;
    }
    if (sellerId != null) {
      _sellerId = sellerId;
    }
    if (buyerItemId != null) {
      _buyerItemId = buyerItemId;
    }
    if (sellerItemId != null) {
      _sellerItemId = sellerItemId;
    }
    if (orderStatus != null) {
      _orderStatus = orderStatus;
    }
    if (buyerName != null) {
      _buyerName = buyerName;
    }
    if (sellerName != null) {
      _sellerName = sellerName;
    }
  }

  String? get orderId => _orderId;
  set orderId(String? orderId) => _orderId = orderId;
  String? get buyerId => _buyerId;
  set buyerId(String? buyerId) => _buyerId = buyerId;
  String? get sellerId => _sellerId;
  set sellerId(String? sellerId) => _sellerId = sellerId;
  String? get buyerItemId => _buyerItemId;
  set buyerItemId(String? buyerItemId) => _buyerItemId = buyerItemId;
  String? get sellerItemId => _sellerItemId;
  set sellerItemId(String? sellerItemId) => _sellerItemId = sellerItemId;
  String? get orderStatus => _orderStatus;
  set orderStatus(String? orderStatus) => _orderStatus = orderStatus;
  String? get buyerName => _buyerName;
  set buyerName(String? buyerName) => _buyerName = buyerName;
  String? get sellerName => _sellerName;
  set sellerName(String? sellerName) => _sellerName = sellerName;

  Order.fromJson(Map<String, dynamic> json) {
    _orderId = json['order_id'];
    _buyerId = json['buyer_id'];
    _sellerId = json['seller_id'];
    _buyerItemId = json['buyer_item_id'];
    _sellerItemId = json['seller_item_id'];
    _orderStatus = json['order_status'];
    _buyerName = json['buyer_name'];
    _sellerName = json['seller_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = _orderId;
    data['buyer_id'] = _buyerId;
    data['seller_id'] = _sellerId;
    data['buyer_item_id'] = _buyerItemId;
    data['seller_item_id'] = _sellerItemId;
    data['order_status'] = _orderStatus;
    data['buyer_name'] = _buyerName;
    data['seller_name'] = _sellerName;
    return data;
  }
}
