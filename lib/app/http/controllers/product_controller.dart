import 'dart:math';

import 'package:blog/app/models/product.dart';
import 'package:blog/app/models/vendor.dart';
import 'package:vania/vania.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    var data = await Product().query().get();
    return Response.json({'message': 'success get products', 'data': data});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    final random = Random();
    String prodId = 'prod${random.nextInt(90).toString().padLeft(6, '0')}';
    request.validate({
      'vend_id': 'required',
      'prod_name': 'required',
      'prod_price': 'required|number',
      'prod_desc': 'required',
    });
    try {
      var vendResponse = await Vendor()
          .query()
          .where('vend_id', '=', request.body['vend_id'])
          .first();

      if (vendResponse == null) {
        return Response.json(
            {'status': false, 'message': 'vendors not found!'}, 404);
      }
      var data = request.all();
      data['prod_id'] = prodId;
      await Product().query().insert(data);
      return Response.json(
          {"status": true, "message": "product created!"}, 201);
    } catch (e) {
      return Response.json({"status": false, "message": e.toString()}, 500);
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String id) async {
    var product = await Product().query().where('prod_id', '=', id).first();
    if (product == null) {
      return Response.json(
          {'status': false, 'message': 'product not found'}, 404);
    }
    request.validate({
      'vend_id': 'required',
      'prod_name': 'required',
      'prod_price': 'required|number',
      'prod_desc': 'required',
    });
    try {
      var vendResponse = await Vendor()
          .query()
          .where('vend_id', '=', request.body['vend_id'])
          .first();

      if (vendResponse == null) {
        return Response.json(
            {'status': false, 'message': 'vendors not found!'}, 404);
      }

      var data = request.all();
      data.remove('id');

      await Product().query().where('prod_id', '=', id).update(data);
      return Response.json(
          {'status': true, "message": 'success update products'}, 200);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()});
    }
  }

  Future<Response> destroy(String id) async {
    var product = await Product().query().where('prod_id', '=', id).first();
    if (product == null) {
      return Response.json(
          {'status': false, 'message': 'product not found'}, 404);
    }
    await Product().query().where('prod_id', '=', id).delete();
    return Response.json(
        {'status': true, "message": 'success delete product'}, 200);
  }
}

final ProductController productController = ProductController();
