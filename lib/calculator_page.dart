import 'package:flutter/material.dart';

class calculator_page extends StatefulWidget {
  const calculator_page({super.key});

  @override
  State<calculator_page> createState() => _calculator_pageState();
}

class _calculator_pageState extends State<calculator_page> {
  String _display = '0';
  String _expression = '';
  double? _storedValue;
  String? _pendingOperation;
  bool _resetDisplay = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = (size.width - 32 - (3 * 10)) / 4;
    final rows = <List<_KeypadButtonData>>[
      [
        _KeypadButtonData('AC', const Color(0xFFD8D8D8), Colors.black, _clear),
        _KeypadButtonData(
          '+/-',
          const Color(0xFFD8D8D8),
          Colors.black,
          _toggleSign,
        ),
        _KeypadButtonData(
          '%',
          const Color(0xFFD8D8D8),
          Colors.black,
          _applyPercentage,
        ),
        _KeypadButtonData(
          '÷',
          const Color(0xFFFF9500),
          Colors.white,
          () => _handleOperation('÷'),
        ),
      ],
      [
        _KeypadButtonData(
          '7',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('7'),
        ),
        _KeypadButtonData(
          '8',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('8'),
        ),
        _KeypadButtonData(
          '9',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('9'),
        ),
        _KeypadButtonData(
          '×',
          const Color(0xFFFF9500),
          Colors.white,
          () => _handleOperation('×'),
        ),
      ],
      [
        _KeypadButtonData(
          '4',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('4'),
        ),
        _KeypadButtonData(
          '5',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('5'),
        ),
        _KeypadButtonData(
          '6',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('6'),
        ),
        _KeypadButtonData(
          '-',
          const Color(0xFFFF9500),
          Colors.white,
          () => _handleOperation('-'),
        ),
      ],
      [
        _KeypadButtonData(
          '1',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('1'),
        ),
        _KeypadButtonData(
          '2',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('2'),
        ),
        _KeypadButtonData(
          '3',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('3'),
        ),
        _KeypadButtonData(
          '+',
          const Color(0xFFFF9500),
          Colors.white,
          () => _handleOperation('+'),
        ),
      ],
      [
        _KeypadButtonData(
          '0',
          const Color(0xFF2F2F2F),
          Colors.white,
          () => _appendDigit('0'),
        ),
        _KeypadButtonData(
          '.',
          const Color(0xFF2F2F2F),
          Colors.white,
          _appendDecimal,
        ),
        _KeypadButtonData(
          '=',
          const Color(0xFFFF9500),
          Colors.white,
          _calculateResult,
        ),
        _KeypadButtonData(
          '⌫',
          const Color(0xFFD8D8D8),
          Colors.black,
          _backspace,
        ),
      ],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B1B),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _expression.isEmpty ? ' ' : _expression,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _display,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                flex: 3,
                child: Column(
                  children: rows
                      .map(
                        (row) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: row
                                  .map(
                                    (button) => Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: _CalculatorButton(
                                          label: button.label,
                                          color: button.color,
                                          textColor: button.textColor,
                                          size: buttonSize,
                                          onTap: button.onTap,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _appendDigit(String digit) {
    setState(() {
      if (_resetDisplay) {
        _display = digit;
        _resetDisplay = false;
      } else if (_display == '0' && digit != '0') {
        _display = digit;
      } else if (_display != '0' || _display.contains('.')) {
        _display += digit;
      } else {
        _display = digit;
      }
    });
  }

  void _appendDecimal() {
    setState(() {
      if (_resetDisplay) {
        _display = '0.';
        _resetDisplay = false;
      } else if (!_display.contains('.')) {
        _display = _display.isEmpty ? '0.' : '$_display.';
      }
    });
  }

  void _toggleSign() {
    setState(() {
      if (_display == '0') return;
      final value = double.parse(_display);
      _display = _formatNumber(-value);
    });
  }

  void _applyPercentage() {
    setState(() {
      final value = double.parse(_display);
      _display = _formatNumber(value / 100);
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _storedValue = null;
      _pendingOperation = null;
      _resetDisplay = false;
    });
  }

  void _backspace() {
    setState(() {
      if (_display.length <= 1) {
        _display = '0';
      } else {
        _display = _display.substring(0, _display.length - 1);
      }
    });
  }

  void _handleOperation(String operation) {
    setState(() {
      final value = double.parse(_display);
      if (_storedValue == null) {
        _storedValue = value;
        _expression = '${_formatNumber(value)} $operation';
        _pendingOperation = operation;
        _resetDisplay = true;
        return;
      }

      if (_pendingOperation != null && !_resetDisplay) {
        final result = _applyOperation(
          _storedValue!,
          value,
          _pendingOperation!,
        );
        _storedValue = result;
        _expression = '${_formatNumber(result)} $operation';
        _display = _formatNumber(result);
      } else {
        _expression = '${_formatNumber(_storedValue!)} $operation';
      }

      _pendingOperation = operation;
      _resetDisplay = true;
    });
  }

  void _calculateResult() {
    if (_storedValue == null || _pendingOperation == null) return;

    setState(() {
      final value = double.parse(_display);
      final result = _applyOperation(_storedValue!, value, _pendingOperation!);
      _display = _formatNumber(result);
      _expression =
          '${_formatNumber(_storedValue!)} $_pendingOperation ${_formatNumber(value)} =';
      _storedValue = result;
      _pendingOperation = null;
      _resetDisplay = true;
    });
  }

  double _applyOperation(double left, double right, String operation) {
    switch (operation) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '×':
        return left * right;
      case '÷':
        return right == 0 ? 0 : left / right;
      default:
        return right;
    }
  }

  String _formatNumber(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }

    return value
        .toString()
        .replaceAll(RegExp(r'\.0+$'), '')
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}

class _CalculatorButton extends StatefulWidget {
  const _CalculatorButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.size,
    required this.onTap,
    this.isWide = false,
  });

  final String label;
  final Color color;
  final Color textColor;
  final double size;
  final VoidCallback onTap;
  final bool isWide;

  @override
  State<_CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<_CalculatorButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      width: widget.size,
      height: widget.size,
      transform: Matrix4.identity()..scale(_pressed ? 0.95 : 1.0),
      child: Material(
        color: widget.color,
        borderRadius: BorderRadius.circular(36),
        child: InkWell(
          borderRadius: BorderRadius.circular(36),
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeypadButtonData {
  const _KeypadButtonData(this.label, this.color, this.textColor, this.onTap);

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
}
