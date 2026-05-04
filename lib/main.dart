import 'package:flutter/material.dart';
import 'classes/machine.dart';
import 'classes/Coffies.dart';

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

  @override
  void initState() {
    super.initState();
    // Начальная синхронизация типа кофе
    _machine.typeCoffee = TypeCoffies.espresso.index;
  }

  void _makeCoffee() async {
    if (_machine.status != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Машина уже готовит кофе, подождите'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    bool success = await _machine.makingCoffee();

    String message;
    Color backgroundColor;
    if (success) {
      message = '${_machine.typeCoffee} готов! С Вас ${_machine.currentPrice} руб.';
      backgroundColor = Colors.green;
    } else {
      message = 'Недостаточно ресурсов для ${_machine.typeCoffee}';
      backgroundColor = Colors.red;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
    }
  }

  void _refill() {
    _machine.refill();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ресурсы пополнены до максимума'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _machine,
      builder: (context, child) {
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
                // Статус машины (обновляется при каждом notifyListeners)
                Container(
                  color: _machine.status == 0 ? Colors.green.shade100 : Colors.red.shade100,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _machine.statusMachine,
                    style: TextStyle(
                      fontSize: 16,
                      color: _machine.status == 0 ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),

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
                      value: TypeCoffies.values.firstWhere(
                        (e) => e.index == _machine.typeCoffeeIndex,
                        orElse: () => TypeCoffies.espresso,
                      ),
                      items: _machine.coffeeTypes.map((type) {
                        String displayName = type.name == "kaputhino"
                            ? "Капучино"
                            : (type.name == "latte" ? "Латте" : "Эспрессо");
                        return DropdownMenuItem(
                          value: type,
                          child: Text(displayName),
                        );
                      }).toList(),
                      onChanged: _machine.status == 0
                          ? (newValue) {
                              if (newValue != null) {
                                _machine.typeCoffee = newValue.index;
                              }
                            }
                          : null, // блокируем выбор во время готовки
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Информация о цене
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Стоимость:', style: TextStyle(fontSize: 16)),
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
                  onPressed: _machine.status == 0 ? _makeCoffee : null,
                  icon: const Icon(Icons.coffee),
                  label: Text(
                    _machine.status == 0
                        ? 'Приготовить ${_machine.typeCoffee}'
                        : 'Готовка...',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                const SizedBox(height: 20),

                // Кнопка пополнения (доступна всегда)
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
      },
    );
  }

  Widget _buildResourceRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}