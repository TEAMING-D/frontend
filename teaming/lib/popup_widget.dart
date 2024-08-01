import 'package:flutter/material.dart';

class PopupWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onConfirm;

  PopupWidget({required this.message, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Container(
          width: 300,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF585454),
                    height: 1.2,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onConfirm != null) {
                          onConfirm!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromRGBO(84, 84, 84, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PopupChoiceWidget extends StatelessWidget {
   final String normalMessage;
   final String? boldMessage;
  final VoidCallback onConfirm;

  PopupChoiceWidget({required this.normalMessage, required this.onConfirm, this.boldMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Container(
          width: 300,
          padding: EdgeInsets.all(11),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 18),
                child: Column(
                  children: [
                    if (boldMessage != null) 
                    Text(
                      boldMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF585454),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      normalMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF585454),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: Color(0xffD8D8D8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(84, 84, 84, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromRGBO(84, 84, 84, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}