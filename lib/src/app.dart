import 'package:flutter/material.dart';
import 'pages/home_page.dart';

class TheFellowsRun extends StatelessWidget{
  const TheFellowsRun ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "The Fellows Run",
      theme: ThemeData(
        colorScheme: ColorScheme(                                                              
          brightness: Brightness.light,                                                                
          primary: Color(0xFF1B5E20),     // verde floresta profundo                                   
          onPrimary: Color(0xFFFFFFFF),                                                                
          secondary: Color(0xFF33691E),   // verde oliva escuro                                        
          onSecondary: Color(0xFFFFFFFF),                                                              
          error: Color(0xFFB00020),                                                                    
          onError: Color(0xFFFFFFFF),                                                                  
          surface: Color(0xFFF1F8E9),     // verde muito claro (quase branco)                          
          onSurface: Color(0xFF1A2B18),   // verde escuro para texto                                   
        ), 
      ),
      home: HomePage(),
    );
  }
}