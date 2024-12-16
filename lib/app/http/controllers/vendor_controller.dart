import 'dart:math';

import 'package:blog/app/models/vendor.dart';
import 'package:vania/vania.dart';

class VendorController extends Controller {
  Future<Response> index() async {
    var vendors = await Vendor().query().get();
    return Response.json({'message': 'Success fetch data', 'vendors': vendors});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    request.validate({
      'vend_name': 'required|string',
      'vend_kota': 'required',
      'vend_state': 'required',
      'vend_zip': 'required',
      'vend_country': 'required'
    });
    try {
      final random = Random();
      String vendId = 'vnd${random.nextInt(90).toString().padLeft(2, '0')}';

      var data = request.all();
      data['vend_id'] = vendId;
      await Vendor().query().insert(data);

      return Response.json(
          {'status': true, 'message': 'vendor created successfully'});
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> show(String id) async {
    try {
      var vendor = await Vendor().query().where('vend_id', id).first();
      if (vendor == null) {
        return Response.json(
            {'status': false, 'message': 'Vendor not found'}, 404);
      }
      return Response.json({'status': true, 'vendor': vendor});
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String id) async {
    Map<String, dynamic>? vendor =
        await Vendor().query().where('vend_id', '=', id).first();

    if (vendor == null) {
      return Response.json(
          {'status': false, 'message': 'Vendor not found'}, 404);
    }
    request.validate({
      'vend_name': 'required|string',
      'vend_kota': 'required',
      'vend_state': 'required',
      'vend_zip': 'required',
      'vend_country': 'required'
    });

    try {
      var data = request.all();
      data.remove('id');
      await Vendor().query().where('vend_id', '=', id).update(data);

      return Response.json(
          {'status': true, 'message': 'Vendor updated successfully'});
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      var vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json(
            {'status': false, 'message': 'Vendor not found'}, 404);
      }

      await Vendor().query().where('vend_id', '=', id).delete();

      return Response.json(
          {'status': true, 'message': 'Vendor deleted successfully'});
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }
}

final VendorController vendorController = VendorController();
