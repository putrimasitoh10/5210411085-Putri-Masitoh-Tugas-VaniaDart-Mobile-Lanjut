import 'dart:math';

import 'package:blog/app/models/customer.dart';
import 'package:blog/app/models/order.dart';
import 'package:vania/vania.dart';

class OrderController extends Controller {
  Future<Response> index() async {
    var orders = await Order()
        .query()
        .join('customers', 'customers.cust_id', '=', 'orders.cust_id')
        .get();
    return Response.json({'message': 'success get orders', 'data': orders});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    request.validate({
      'order_date': 'required',
      'cust_id': 'required',
    });

    try {
      var data = request.all();

      var random = Random();

      var customer = await Customer()
          .query()
          .where('cust_id', '=', request.body['cust_id'])
          .first();
      if (customer == null) {
        return Response.json(
            {'status': false, 'message': 'customer id not found'}, 404);
      }
      int? orderNum =
          random.nextInt(999999).toString().padLeft(11, '0').toInt();

      data['order_num'] = orderNum;

      await Order().query().insert(data);
      return Response.json(
          {'status': true, 'message': 'success create order'}, 201);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> show(int id) async {
    var order = await Order().query().where('order_num', '=', id).first();
    if (order == null) {
      return Response.json(
          {'status': false, 'message': 'order not found'}, 404);
    }
    return Response.json({'status': true, 'data': order});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    var order = await Order().query().where('order_num', '=', id).first();
    if (order == null) {
      return Response.json(
          {'status': false, 'message': 'order not found'}, 404);
    }

    request.validate({
      'order_date': 'required',
      'cust_id': 'required',
    });

    try {
      var data = request.all();

      data.remove('id');
      await Order().query().where('order_num', '=', id).update(data);
      return Response.json(
          {'status': true, 'message': 'Order updated successfully'}, 200);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> destroy(int id) async {
    var order = await Order().query().where('order_num', '=', id).first();
    if (order == null) {
      return Response.json(
          {'status': false, 'message': 'order not found'}, 404);
    }

    try {
      await Order().query().where('order_num', '=', id).delete();
      return Response.json(
          {'status': true, 'message': 'Order deleted successfully'}, 200);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }
}

final OrderController orderController = OrderController();
