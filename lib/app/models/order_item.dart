import 'package:vania/vania.dart';

class OrderItem extends Model {
  OrderItem() {
    super.table('orderitems');
  }

  List<String> columns() => [
        'order_item',
        'order_num',
        'prod_id',
        'quantity',
        'size',
        'created_at',
        'updated_at'
      ];
}
