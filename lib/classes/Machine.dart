import 'package:coffee_machine/interfaces/ICoffee.dart';

import 'Coffies.dart';
import 'Resources.dart';


class Machine {
  final Resources _resources = Resources();

  TypeCoffies _coffies = TypeCoffies.espresso;

  int get coffeeBeans => _resources.coffeeBeans;
  int get milk => _resources.milk;
  int get water => _resources.water;
  int get cash =>  _resources.cash;

  
  String get typeCoffee => _coffies.name;

  set typeCoffee(int value) {
    if(value == TypeCoffies.espresso.index){
      _coffies = TypeCoffies.espresso;
    }
    else if(value == TypeCoffies.kaputhino.index){
      _coffies = TypeCoffies.kaputhino;
    }
    else {
      _coffies = TypeCoffies.latte;
    }}

  int get currentPrice => _coffies.getCoffee().cash();
  List<TypeCoffies> get coffeeTypes => TypeCoffies.values;

  set coffeeBeans(int value) => _resources.coffeeBeans = value;
  set milk(int value) => _resources.milk = value;
  set water(int value) => _resources.water = value;
  set cash(int value) => _resources.cash = value;

  bool isAvailableResources() {
    ICoffee coffee = _coffies.getCoffee();
    return _resources.coffeeBeans >= coffee.coffeeBeans() && _resources.milk >= coffee.milk() && _resources.water >= coffee.water();
  }

  void _subtractResources() {
    ICoffee coffee = _coffies.getCoffee();
    _resources.coffeeBeans -= coffee.coffeeBeans();
    _resources.milk -= coffee.milk();
    _resources.water -= coffee.water();
  }

  bool makingCoffee() {
    ICoffee coffee = _coffies.getCoffee();
    if (isAvailableResources()) {
      _subtractResources();
      _resources.cash += coffee.cash();
      return true;
    }
    return false;
  }

  void refill() {
    _resources.refill();
  }
}



