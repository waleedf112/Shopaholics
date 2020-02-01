class Product {
  String productName;
  double _price;
  double _discount = 0.0;

  Product({this.productName});

  setDiscount(discount) => this._discount = discount.toDouble();
  hasDiscount() => this._discount > 0.0;
  setPrice(price) => this._price = price.toDouble();
  getPrice() => this._price - ((this._price * this._discount) / 100);
  getOldPrice() => this._price;
}
