import 'package:coffee_machine/interfaces/ICoffee.dart';

enum TypeCoffies {
  latte,
  kaputhino,
  espresso;
  ICoffee getCoffee(){
    switch(this){
      case TypeCoffies.espresso:
        return Espresso();
      case TypeCoffies.kaputhino:
        return Kaputhino();
      case TypeCoffies.latte:
        return Latte();
    }
  }
}



class Latte extends ICoffee{
  @override
  int cash() {
    return 250;
  }

  @override
  int coffeeBeans() {
    return 20;
  }

  @override
  int milk() {
    return 150;
  }

  @override
  int water() {
    return 50;
  }
}

class Kaputhino extends ICoffee{
  @override
  int cash() {
    return 200;
  }

  @override
  int coffeeBeans() {
    return 20;
  }

  @override
  int milk() {
    return 80;
  }

  @override
  int water() {
    return 50;
  }
}

class Espresso extends ICoffee{
  @override
  int cash() {
    return 150;
  }

  @override
  int coffeeBeans() {
    return 20;
  }

  @override
  int milk() {
    return 0;
  }

  @override
  int water() {
    return 50;
  }
}