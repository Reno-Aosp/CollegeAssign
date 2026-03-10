import 'package:flutter/material.dart';

void main() => runApp(const TempConverterApp());

class TempConverterApp extends StatelessWidget {
  const TempConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _controller = TextEditingController();
  String _fromUnit = 'Celsius';
  double? _inputValue;

  final List<String> _units = ['Celsius', 'Fahrenheit', 'Kelvin'];

  // Convert any unit → Celsius first, then → target
  double _toCelsius(double value, String unit) {
    switch (unit) {
      case 'Fahrenheit':
        return (value - 32) * 5 / 9;
      case 'Kelvin':
        return value - 273.15;
      default:
        return value;
    }
  }

  double _fromCelsius(double celsius, String unit) {
    switch (unit) {
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  double _convert(double value, String from, String to) {
    final celsius = _toCelsius(value, from);
    return _fromCelsius(celsius, to);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Field
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: 'Enter temperature',
                border: const OutlineInputBorder(),
                suffixText: _unitSymbol(_fromUnit),
              ),
              onChanged: (val) {
                setState(() {
                  _inputValue = double.tryParse(val);
                });
              },
            ),
            const SizedBox(height: 16),

            // From unit selector
            DropdownButtonFormField<String>(
              value: _fromUnit,
              decoration: const InputDecoration(
                labelText: 'Convert from',
                border: OutlineInputBorder(),
              ),
              items:
                  _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
              onChanged: (val) => setState(() => _fromUnit = val!),
            ),
            const SizedBox(height: 24),

            // Results Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Results',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ..._units
                        .where((u) => u != _fromUnit)
                        .map((toUnit) => _buildResultRow(toUnit)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String toUnit) {
    final input = _inputValue;
    String result;

    if (input == null) {
      result = '—';
    } else {
      final converted = _convert(input, _fromUnit, toUnit);
      result = '${converted.toStringAsFixed(2)} ${_unitSymbol(toUnit)}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(toUnit, style: const TextStyle(fontSize: 16)),
          Text(
            result,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  String _unitSymbol(String unit) {
    switch (unit) {
      case 'Celsius':
        return '°C';
      case 'Fahrenheit':
        return '°F';
      case 'Kelvin':
        return 'K';
      default:
        return '';
    }
  }
}
