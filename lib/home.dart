import 'register.dart';
import 'package:flutter/material.dart';
import 'login.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BookBack.png'),
                fit: BoxFit.cover,
              )
          ),
          child:SingleChildScrollView(
            child:Center(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const CircleAvatar(

                    radius: 100, // Specify the desired radius of the circular avatar
                    backgroundImage:  AssetImage('assets/images/BookLogo.png'),
                  ),
                  const SizedBox(height: 30,),
                  const Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text("Welcome to the application,", style: TextStyle(fontSize: 18),textAlign:  TextAlign.center),
                        Text("Please  log in or sign up in order to continue using the app", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),

                      ],
                    ),
                  ),
                  const SizedBox(height:30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        fixedSize: const Size(250, 40)
                    ),
                    label: const Text('Log In', style: TextStyle(fontSize: 18, color: Colors.purple),),
                    onPressed:(){Navigator.push(context,MaterialPageRoute(
                        builder: (context) => const LogIn()),);},
                    icon: const Icon(Icons.login),
                  ),
                  const Text("If you have an account already", style: TextStyle(fontSize: 10,)),
                  const SizedBox(height: 10,),
                  const Text("OR", style: TextStyle(fontSize:13)),
                  const SizedBox(height: 10,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        fixedSize: const Size(250, 40)
                    ),
                    label: const Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.purple), ),
                    onPressed:(){Navigator.push(context,MaterialPageRoute(
                        builder: (context) => const Register()),);},
                    icon: const Icon(Icons.how_to_reg),
                  ),
                  const Text("If you are new", style: TextStyle(fontSize: 10),)
                ],
              ),
            ),
          ),
        )
    );
  }
}
