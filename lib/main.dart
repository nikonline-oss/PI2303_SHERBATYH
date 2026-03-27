import 'package:flutter/material.dart';
import 'classes/machine.dart';
import 'classes/Coffies.dart'; // импортируем enum для работы со значениями

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      home: const CoffeeMachineScreen(),
    );
  }
}

class CoffeeMachineScreen extends StatefulWidget {
  const CoffeeMachineScreen({super.key});

  @override
  State<CoffeeMachineScreen> createState() => _CoffeeMachineScreenState();
}

class _CoffeeMachineScreenState extends State<CoffeeMachineScreen> {
  final Machine _machine = Machine();
  TypeCoffies _selectedCoffee = TypeCoffies.espresso; // текущий выбранный тип

  @override
  void initState() {
    super.initState();
    // Синхронизируем начальное состояние с машиной
    _machine.typeCoffee = _selectedCoffee.index;
  }

  void _makeCoffee() {
    // Устанавливаем выбранный тип перед приготовлением
    _machine.typeCoffee = _selectedCoffee.index;

    bool success = _machine.makingCoffee();
    setState(() {});

    String message;
    Color backgroundColor;

    if (success) {
      message = '${_machine.typeCoffee} готов! С Вас ${_machine.currentPrice} руб.';
      backgroundColor = Colors.green;
    } else {
      message = 'Недостаточно ресурсов для ${_machine.typeCoffee}';
      backgroundColor = Colors.red;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _refill() {
    _machine.refill();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ресурсы пополнены до максимума'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофемашина'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Карточка с ресурсами
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResourceRow('Кофе (г)', _machine.coffeeBeans),
                    const Divider(),
                    _buildResourceRow('Молоко (мл)', _machine.milk),
                    const Divider(),
                    _buildResourceRow('Вода (мл)', _machine.water),
                    const Divider(),
                    _buildResourceRow('Деньги (руб)', _machine.cash),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Выбор типа кофе
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Выберите кофе:',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<TypeCoffies>(
                  value: _selectedCoffee,
                  items: _machine.coffeeTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCoffee = newValue;
                        // Сразу обновляем тип в машине
                        _machine.typeCoffee = newValue.index;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Информация о цене выбранного кофе
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Стоимость:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${_machine.currentPrice} руб.',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Кнопка приготовления
            ElevatedButton.icon(
              onPressed: _makeCoffee,
              icon: const Icon(Icons.coffee),
              label: Text('Приготовить ${_selectedCoffee.name}'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка пополнения
            OutlinedButton.icon(
              onPressed: _refill,
              icon: const Icon(Icons.refresh),
              label: const Text('Пополнить ресурсы'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            '$value',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}