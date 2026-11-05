import 'package:flutter/material.dart';

class Calcolatrice extends StatefulWidget {
  const Calcolatrice({super.key});
  
  State<Calcolatrice> createState() => _StateCalc();
}

class _StateCalc extends State<Calcolatrice> {

  Operazione? op = null;
  int showed_value = 0;
  int backed_value = 0;

  void update({int? value, Operazione? op}) {
    setState(() {
      if (op != null) {
        this.op = op; 
        backed_value = showed_value; 
        showed_value = 0; 
        return;
      }
      if (value == null) return;

      showed_value = showed_value*10+value;
    });
  }

  void calculate() {
    setState(() {
      if (op == null) return;

      switch (op) {
        case Operazione.SUM:
          showed_value+=backed_value;
          break;
        case Operazione.DIFFERENCE:
          showed_value = backed_value - showed_value;
          break;
        case Operazione.PRODUCT:
          showed_value = backed_value * showed_value;
          break;
        case Operazione.DIVISION:
          showed_value = backed_value ~/ showed_value;
          break;
        default: break;
      }
      op = null;
    });
  }

  void clear() {
    setState(() {
      op = null;
      showed_value = 0;
      backed_value = 0;
    });
  }

  @override
  Widget build(BuildContext bc) {
    return Column(
      children: [
        CalcScreen(title: showed_value.toString()),
        CalcBtns(
          onDigit: (v) => update(value: v),
          onOp: (o) => update(op: o),
          onEquals: calculate,
          onClear: clear,
        ),
      ],
    );
  }
}

class CalcScreen extends StatelessWidget {
  final String title;
  const CalcScreen({super.key, this.title='0'});

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class CalcBtns extends StatelessWidget {
  final void Function(int) onDigit;
  final void Function(Operazione) onOp;
  final VoidCallback onEquals;
  final VoidCallback onClear;

  CalcBtns({super.key, required this.onDigit, required this.onOp, required this.onEquals, required this.onClear});

  @override
  Widget build(BuildContext context) {
    List<Widget> bottoni = [
      CalcBtn(title: '7', callback: () => onDigit(7)),
      CalcBtn(title: '8', callback: () => onDigit(8)),
      CalcBtn(title: '9', callback: () => onDigit(9)),
      CalcBtn(title: '/', callback: () => onOp(Operazione.DIVISION)),
      CalcBtn(title: '4', callback: () => onDigit(4)),
      CalcBtn(title: '5', callback: () => onDigit(5)),
      CalcBtn(title: '6', callback: () => onDigit(6)),
      CalcBtn(title: '*', callback: () => onOp(Operazione.PRODUCT)),
      CalcBtn(title: '1', callback: () => onDigit(1)),
      CalcBtn(title: '2', callback: () => onDigit(2)),
      CalcBtn(title: '3', callback: () => onDigit(3)),
      CalcBtn(title: '-', callback: () => onOp(Operazione.DIFFERENCE)),
      CalcBtn(title: 'C', callback: onClear),
      CalcBtn(title: '0', callback: () => onDigit(0)),
      CalcBtn(title: '=', callback: onEquals),
      CalcBtn(title: '+', callback: () => onOp(Operazione.SUM)),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      childAspectRatio: 2,
      children: bottoni,
    );
  }
}

class CalcBtn extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const CalcBtn({super.key, required this.title, required this.callback});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: callback,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(4),
        minimumSize: const Size(40, 40),
      ),
      child: Text(title),
    );
  }
}

enum Operazione {
  SUM, DIFFERENCE, PRODUCT, DIVISION
}