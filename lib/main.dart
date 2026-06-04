import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}
  bool isDarkMode = true;

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: CalculatorScreen(isDarkMode: isDarkMode, toggleTheme: toggleTheme),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const CalculatorScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = "";
  String display = "0";

  double firstNumber = 0;
  String operation = "";

  void onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        expression = "";
        display = "0";
        firstNumber = 0;
        operation = "";
      } else if (value == "+" || value == "-" || value == "x" || value == "÷") {
        firstNumber = double.parse(display);

        operation = value;
        expression = "$display $value";
        display = "0";
      } else if (value == "=") {
        double secondNumber = double.parse(display);

        double result = 0;

        switch (operation) {
          case "+":
            result = firstNumber + secondNumber;
            break;

          case "-":
            result = firstNumber - secondNumber;
            break;

          case "x":
            result = firstNumber * secondNumber;
            break;

          case "÷":
            result = firstNumber / secondNumber;
            break;
        }

        expression = "$firstNumber $operation $secondNumber";
        display = result.toString();

        if (display.endsWith(".0")) {
          display = display.substring(0, display.length - 2);
        }
      } else {
        if (display == "0") {
          display = value;
        } else {
          display += value;
        }

        if (operation.isNotEmpty) {
          expression = "$firstNumber $operation $display";
        }
      }
    });
  }

  Widget buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SizedBox(
          height: 75,
          child: ElevatedButton(
            onPressed: () => onButtonPressed(text),
            child: Text(
              text,
              style: TextStyle(
                color: text == "C" ? const Color.fromARGB(255, 250, 1, 1): "+-x÷=".contains(text)? Colors.orange: isDarkMode == true? Colors.white: Colors.black,
                fontSize: 28, fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calculator",
          style: TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        elevation: 10,
        shadowColor:  Colors.amber,
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expression,
                    style: const TextStyle(fontSize: 28, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    display,
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 32.0,
            ),
            child: Container(height: 1, color: Colors.amber),
          ),

          Row(
            children: [
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("÷"),
            ],
          ),

          Row(
            children: [
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("x"),
            ],
          ),

          Row(
            children: [
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("-"),
            ],
          ),

          Row(
            children: [
              buildButton("C"),
              buildButton("0"),
              buildButton("="),
              buildButton("+"),
            ],
          ),
        ],
      ),
    );
  }
}
