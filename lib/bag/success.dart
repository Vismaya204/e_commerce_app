import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
                
                 Image.asset("assets/successimg.png"),
                    
                                 
                 
              
            ],
          ),
        ),
      ),
    );
  }
}
