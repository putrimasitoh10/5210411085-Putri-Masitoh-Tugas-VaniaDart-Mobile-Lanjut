import 'dart:math';

import 'package:blog/app/models/customer.dart';
import 'package:vania/vania.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    var customers = await Customer().query().get();
    return Response.json(
        {'message': 'success get customers', 'data': customers});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    var random = Random();
    String custId = 'cs${random.nextInt(90).toString().padLeft(3, '0')}';

    request.validate({
      'cust_name': 'required',
      'cust_address': 'required',
      'cust_city': 'required',
      'cust_state': 'required',
      'cust_zip': 'required',
      'cust_country': 'required',
      'cust_telp': 'required'
    });

    try {
      var data = request.all();
      data['cust_id'] = custId;

      await Customer().query().insert(data);
      return Response.json(
          {'status': true, 'message': 'success create customer'}, 201);
    } catch (e) {
      return Response.json({'status': true, 'message': e.toString()}, 500);
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String id) async {
    var customer = await Customer().query().where('cust_id', '=', id).first();
    if (customer == null) {
      return Response.json(
          {'status': false, 'message': 'customer not found'}, 404);
    }
    request.validate({
      'cust_name': 'required',
      'cust_address': 'required',
      'cust_city': 'required',
      'cust_state': 'required',
      'cust_zip': 'required',
      'cust_country': 'required',
      'cust_telp': 'required'
    });
    try {
      var data = request.all();
      data.remove('id');
      await Customer().query().where('cust_id', '=', id).update(data);
      return Response.json(
          {'status': true, 'message': 'Customer updated successfully'}, 200);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      var customer = await Customer().query().where('cust_id', '=', id).first();
      if (customer == null) {
        return Response.json(
            {'status': false, 'message': 'customer not found'}, 404);
      }

      await Customer().query().where('cust_id', '=', id).delete();
      return Response.json(
          {'status': true, 'message': 'Customer deleted successfully'}, 200);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }
}

final CustomerController customerController = CustomerController();
