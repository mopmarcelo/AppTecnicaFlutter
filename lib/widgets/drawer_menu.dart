import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {

  final IconData icon;
  final String text;

  DrawerMenu(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color:  Colors.grey[700],
              ),
              SizedBox(width: 32.0,),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color:  Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
