import 'package:coffee_machine/interfaces/ICoffee.dart';
import 'package:flutter/foundation.dart';

import 'Coffies.dart';
import 'Resources.dart';
import 'async.dart';

class Machine extends ChangeNotifier {
  final Resources _resources = Resources();
  final AsyncOperations _asyncOperations = AsyncOperations();

  int _status = 0; // 0 - готов к работе, 1 - в процессе приготовления, 2 - ошибка

  TypeCoffies _coffies = TypeCoffies.espresso;

  int get coffeeBeans => _resources.coffeeBeans;
  int get milk => _resources.milk;
  int get water => _resources.water;
  int get cash => _resources.cash;
  int get status => _status;
  String get statusMachine => status == 0
      ? "Готов к работе"
      : (status == 1 ? "В процессе приготовления" : "Ошибка");
  int get typeCoffeeIndex => _coffies.index;

  String get typeCoffee => _coffies.name;

  set typeCoffee(int value) {
    if (value == TypeCoffies.espresso.index) {
      _coffies = TypeCoffies.espresso;
    } else if (value == TypeCoffies.kaputhino.index) {
      _coffies = TypeCoffies.kaputhino;
    } else {
      _coffies = TypeCoffies.latte;
    }
  }

  set status(int value) {
    if (_status != value) {
      _status = value;
      notifyListeners(); // уведомляем подписчиков
    }
  }

  int get currentPrice => _coffies.getCoffee().cash();
  List<TypeCoffies> get coffeeTypes => TypeCoffies.values;

  set coffeeBeans(int value) {
    _resources.coffeeBeans = value;
    notifyListeners();
  }

  set milk(int value) {
    _resources.milk = value;
    notifyListeners();
  }

  set water(int value) {
    _resources.water = value;
    notifyListeners();
  }

  set cash(int value) {
    _resources.cash = value;
    notifyListeners();
  }

  Future<void> _isAvailableMilk(ICoffee coffee) async {
    if (coffee.milk() > 0) {
      await _asyncOperations.frothMilk();
    }
  }

  Future<void> _isAvailableCoffee(ICoffee coffee) async {
    if (coffee.coffeeBeans() > 0) {
      await _asyncOperations.brewCoffee();
    }
  }

  bool isAvailableResources() {
    if (status == 1) {
      return false;
    }
    ICoffee coffee = _coffies.getCoffee();
    return _resources.coffeeBeans >= coffee.coffeeBeans() &&
        _resources.milk >= coffee.milk() &&
        _resources.water >= coffee.water();
  }

  Future<void> _cookeCoffee() async {
    ICoffee coffee = _coffies.getCoffee();
    print("_Start_");
    status = 1;
    _resources.water -= coffee.water();
    await _asyncOperations.heatWater();
    print("_Then_");
    _resources.coffeeBeans -= coffee.coffeeBeans();
    _resources.milk -= coffee.milk();
    await Future.wait([_isAvailableMilk(coffee), _isAvailableCoffee(coffee)]);
    status = 0;
    print("_End_");
  }

  Future<bool> makingCoffee() async {
    ICoffee coffee = _coffies.getCoffee();
    if (isAvailableResources()) {
      await _cookeCoffee();
      _resources.cash += coffee.cash();
      return true;
    }
    return false;
  }

  void refill() {
    _resources.refill();
  }
}
