import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? age;
  String? firstName;
  String? lastName;
  String? gender;
  String? birthDate;
  String? name;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Вызов функции для загрузки данных пользователя при инициализации
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse('https://dummyjson.com/users/1'); // URL к API

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          firstName = data['firstName'];
          lastName = data['lastName'];
          age = data['age'];
          gender = data['gender'];
          birthDate = data['birthDate'];
          name = (firstName! + ' ' + lastName!);
        });
        print(
            'User data updated: $firstName $lastName, age: $age, gender: $gender, birthDate: $birthDate'); // Логирование обновленных данных
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              width: 28,
              height: 14,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              const Avatar(
                size: 120,
                borderWidth: 3,
                innerColor: Color.fromRGBO(217, 217, 217, 1),
                borderGradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(1, 80, 236, 1),
                    Color.fromRGBO(185, 116, 245, 1)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  name?.toString() ?? 'Loading',
                  
                  //'$firstName $lastName',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: UserInfo(
                  age: age,
                  gender: gender,
                  birthDate: birthDate,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(color: Color.fromRGBO(233, 239, 241, 1)),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 50),
                child: Text(
                  'Additional information',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              const QuestionMarkWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

// Добавлен конструктор в UserInfo для приема данных пользователя
class UserInfo extends StatelessWidget {
  final int? age;
  final String? gender;
  final String? birthDate;

  const UserInfo({
    super.key,
    required this.age,
    required this.gender,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          UserInfoPart(
            label: 'age',
            value: age?.toString() ?? 'Loading',
          ),
          const VerticalDivider(
            width: 2,
            thickness: 2,
            color: Color.fromRGBO(233, 239, 241, 1),
          ),
          UserInfoPart(
            label: 'gender',
            value: gender ?? 'Loading',
          ),
          const VerticalDivider(
            width: 2,
            thickness: 2,
            color: Color.fromRGBO(233, 239, 241, 1),
          ),
          UserInfoPart(
            label: 'birth',
            value: birthDate ?? 'Loading',
          ),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final double borderWidth;
  final Gradient borderGradient;
  final Color innerColor;

  const Avatar({
    super.key,
    required this.size,
    required this.borderWidth,
    required this.borderGradient,
    required this.innerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: borderGradient),
      child: Center(
        child: Container(
          height: size - 2 * borderWidth,
          width: size - 2 * borderWidth,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Center(
            child: Container(
              height: size - 4 * borderWidth,
              width: size - 4 * borderWidth,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: innerColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfoPart extends StatelessWidget {
  final String label;
  final String value;
  const UserInfoPart({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class QuestionMarkWidget extends StatelessWidget {
  const QuestionMarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 284,
      height: 277,
      alignment: Alignment.center,
      child: const Text(
        '?',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 250,
          fontWeight: FontWeight.w500,
          height: 1.21,
          letterSpacing: 0.02,
          color: Colors.black,
        ),
      ),
    );
  }
}
