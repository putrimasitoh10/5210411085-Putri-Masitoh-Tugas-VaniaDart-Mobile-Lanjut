import 'dart:math';

import 'package:blog/app/models/order.dart';
import 'package:blog/app/models/order_item.dart';
import 'package:blog/app/models/product.dart';
import 'package:vania/vania.dart';

class OrderItemController extends Controller {
  Future<Response> index() async {
    var orderItems = await OrderItem()
        .query()
        .join('orders', 'orders.order_num', '=', 'orderitems.order_num')
        .join('customers', 'customers.cust_id', '=', 'orders.cust_id')
        .get();

    return Response.json(
        {'message': 'success get order items', 'data': orderItems});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    request.validate({
      'order_num': 'required',
      'prod_id': 'required',
      'quantity': 'required',
      'size': 'required',
    });
    try {
      var data = request.all();
      var random = Random();
      var order = await Order()
          .query()
          .where('order_num', '=', request.body['order_num'])
          .first();
      if (order == null) {
        return Response.json({
          'status': false,
          'message':
              'Ops, order not found please create order before make orderitem'
        });
      }
      var prod = await Product()
          .query()
          .where('prod_id', '=', request.body['prod_id'])
          .first();

      if (prod == null) {
        return Response.json({
          'status': false,
          'message':
              'Ops, order not found please create product before make orderitem'
        });
      }
      int orderItem = random.nextInt(1000);
      data['order_item'] = orderItem;
      await OrderItem().query().insert(data);
      return Response.json(
          {'status': true, 'message': 'success create order item'}, 201);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> show(int id) async {
    var orderItem =
        await OrderItem().query().where('order_item', '=', id).first();
    if (orderItem == null) {
      return Response.json(
          {'status': false, 'message': 'order item not found'}, 404);
    }
    return Response.json({'status': true, 'data': orderItem});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    var orderItem =
        await OrderItem().query().where('order_item', '=', id).first();
    if (orderItem == null) {
      return Response.json(
          {'status': false, 'message': 'order item not found'}, 404);
    }

    request.validate({
      'order_num': 'required',
      'prod_id': 'required',
      'quantity': 'required',
      'size': 'required',
    });

    try {
      var data = request.all();
      data.remove('id');
      await OrderItem().query().where('order_item', '=', id).update(data);
      return Response.json(
          {'status': true, 'message': 'Order item updated successfully'}, 200);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> destroy(int id) async {
    var orderItem =
        await OrderItem().query().where('order_item', '=', id).first();
    if (orderItem == null) {
      return Response.json(
          {'status': false, 'message': 'order item not found'}, 404);
    }

    try {
      await OrderItem().query().where('order_item', '=', id).delete();
      return Response.json(
          {'status': true, 'message': 'Order item deleted successfully'}, 200);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }
}

final OrderItemController orderItemController = OrderItemController();
