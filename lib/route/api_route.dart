import 'package:blog/app/http/controllers/customer_controller.dart';
import 'package:blog/app/http/controllers/order_controller.dart';
import 'package:blog/app/http/controllers/order_item_controller.dart';
import 'package:blog/app/http/controllers/product_controller.dart';
import 'package:blog/app/http/controllers/productnotes_controller.dart';
import 'package:blog/app/http/controllers/vendor_controller.dart';
import 'package:vania/vania.dart';
import 'package:blog/app/http/controllers/home_controller.dart';
import 'package:blog/app/http/middleware/authenticate.dart';
import 'package:blog/app/http/middleware/home_middleware.dart';
import 'package:blog/app/http/middleware/error_response_middleware.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.get("/home", homeController.index);

    // vendors
    Router.get('/vendors', vendorController.index);
    Router.post("/vendors", vendorController.store);
    Router.put("/vendors/{id}", vendorController.update);
    Router.delete("/vendors/{id}", vendorController.destroy);

    // products

    Router.get('/products', productController.index);
    Router.post('/products', productController.store);
    Router.put('/products/{id}', productController.update);
    Router.delete('/products/{id}', productController.destroy);

    // notes
    Router.get('/notes', productnotesController.index);
    Router.post('/notes', productnotesController.store);
    Router.put('/notes/{id}', productnotesController.update);
    Router.delete('/notes/{id}', productnotesController.destroy);

    // customers

    Router.get('/customers', customerController.index);
    Router.post('/customers', customerController.store);
    Router.put('/customers/{id}', customerController.update);
    Router.delete('/customers/{id}', customerController.destroy);

    // orders

    Router.get('/orders', orderController.index);
    Router.post('/orders', orderController.store);
    Router.put('/orders/{id}', orderController.update);
    Router.delete('/orders/{id}', orderController.destroy);

    // order item

    Router.get('/orderitem', orderItemController.index);
    Router.post('/orderitem', orderItemController.store);
    Router.put('/orderitem/{id}', orderItemController.update);
    Router.delete('/orderitem/{id}', orderItemController.destroy);

    // Return error code 400
    Router.get('wrong-request',
            () => Response.json({'message': 'Hi wrong request'}))
        .middleware([ErrorResponseMiddleware()]);

    // Return Authenticated user data
    Router.get("/user", () {
      return Response.json(Auth().user());
    }).middleware([AuthenticateMiddleware()]);
  }
}
