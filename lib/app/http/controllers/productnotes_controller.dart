import 'dart:math';

import 'package:blog/app/models/product.dart';
import 'package:blog/app/models/product_notes.dart';
import 'package:vania/vania.dart';

class ProductnotesController extends Controller {
  Future<Response> index() async {
    var products = await ProductNotes()
        .query()
        .join('products', 'products.prod_id', '=', 'productnotes.prod_id')
        .get();
    return Response.json(
        {'message': 'success get products notes', 'data': products});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    request.validate({
      'prod_id': 'required',
      'note_date': 'required|date',
      'note_text': 'required'
    });
    final random = Random();
    String prodNoteId = 'pnt${random.nextInt(90).toString().padLeft(2, '0')}';
    var prod = await Product()
        .query()
        .where('prod_id', '=', request.body['prod_id'])
        .first();
    if (prod == null) {
      return Response.json({'status': false, 'message': 'product not found'});
    }
    try {
      var data = request.all();
      data['note_id'] = prodNoteId;
      await ProductNotes().query().insert(data);
      return Response.json(
          {'status': true, 'message': 'success create product note'}, 201);
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()}, 500);
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String id) async {
    request.validate({
      'prod_id': 'required',
      'note_date': 'required|date',
      'note_text': 'required'
    });
    try {
      var prod = await Product()
          .query()
          .where('prod_id', '=', request.body['prod_id'])
          .first();
      if (prod == null) {
        return Response.json({'status': false, 'message': 'product not found'});
      }
      var note = await ProductNotes().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json(
            {'status': false, 'message': 'ops, product note not found'});
      }
      var data = request.all();
      data.remove('id');
      ProductNotes().query().where('note_id', '=', id).update(data);
      return Response.json(
          {'status': true, 'message': 'product note update success'});
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()});
    }
  }

  Future<Response> destroy(String id) async {
    try {
      var note = await ProductNotes().query().where('note_id', '=', id).first();
      print(note);
      if (note == null) {
        return Response.json(
            {'status': false, 'message': 'ops, product note not found'});
      }

      await ProductNotes().query().where('note_id' ,'=' , id).delete();
      return Response.json(
          {'status': true, 'message': 'product notes deleted successfully'});
    } catch (e) {
      return Response.json({'status': false, 'message': e.toString()});
    }
  }
}

final ProductnotesController productnotesController = ProductnotesController();
