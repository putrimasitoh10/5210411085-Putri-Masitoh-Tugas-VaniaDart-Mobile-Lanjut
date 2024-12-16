import 'package:vania/vania.dart';

class CreateCustomersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('customers', () {
      char('cust_id', length: 5, unique: true);
      primary('cust_id');
      string('cust_name', length: 50);
      string('cust_address', length: 50);
      string('cust_city', length: 50);
      string('cust_state', length: 50);
      string('cust_zip', length: 50);
      string('cust_country', length: 50);
      string('cust_telp', length: 50);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('customers');
  }
}
