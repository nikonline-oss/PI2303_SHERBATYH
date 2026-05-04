// 2. Создать метод для нагрева воды. Задержка 3 секунды.
// 3. Создать метод заваривания кофе (после нагрева воды) Задержка 5 секунд.
// 4. Создать метод для взбивания молока (запускается вместе с завари-ванием кофе). Задержка 5 секунд
// 5. Создать метод для смешивания кофе и молока (запускается после приготовления кофе и молока). Задержка 3 секунды
// 6. Реализовать вывод технических сообщений в консоль.
// 7. Добавить вызов методов в фабричный конструктор.


class AsyncOperations {
  Future<void> heatWater() async {
    print('Start_process: Нагрев воды...');
    await Future.delayed(Duration(seconds: 3));
    print('Done_process: Вода нагрета.');
  }

  Future<void> brewCoffee() async {
    print('Start_process: Заваривание кофе...');
    await Future.delayed(Duration(seconds: 5));
    print('Done_process: Кофе заварен.');
  }

  Future<void> frothMilk() async {
    print('Start_process: Взбивание молока...');
    await Future.delayed(Duration(seconds: 5));
    print('Done_process: Молоко взбито.');
  }

  Future<void> mixCoffeeAndMilk() async {
    print('Start_process: Смешиваем кофе и молоко...');
    await Future.delayed(Duration(seconds: 3));
    print('Done_process: Кофе с молоком готов.');
  }
}
