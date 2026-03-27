class Resources {
  int _coffeeBeans;
  int _milk;
  int _water;
  int _cash;

  Resources({
    int coffeeBeans = 500,
    int milk = 500,
    int water = 1000,
    int cash = 0,
  }) : _coffeeBeans = coffeeBeans,
       _milk = milk,
       _water = water,
       _cash = cash;

    int get coffeeBeans => _coffeeBeans;
    int get milk => _milk;
    int get water => _water;
    int get cash => _cash;

    set coffeeBeans(int value) => _coffeeBeans = value;
    set milk(int value) => _milk = value;
    set water(int value) => _water = value;
    set cash(int value) => _cash = value;

    void refill() {
    _coffeeBeans = 500;
    _milk = 500;
    _water = 1000;
  }
}
