import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Onboarding(),
  ));
}

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboard1.png",
      "title": "Track Your Daily Calories",
      "description": "Easily monitor your calorie burn with Card.io.",
    },
    {
      "image": "assets/images/onboard2.png",
      "title": "Machine Learning Health Predictor",
      "description":
          "Predicts heart rate, body temperature, and calorie burn using steps and personal factors.",
    },
    {
      "image": "assets/images/onboard3.png",
      "title": "Dockerized App for Easy Deployment",
      "description": "Pull and run the app on your device using Docker.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserInfoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) => OnboardWidgets(
                  image: onboardingData[index]["image"]!,
                  title: onboardingData[index]["title"]!,
                  description: onboardingData[index]["description"]!,
                ),
              ),
            ),
            SizedBox(
              height: _currentPage == onboardingData.length - 1 ? 50 : 70,
              width: _currentPage == onboardingData.length - 1 ? 200 : 70,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _navigateToNextScreen(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: _currentPage == onboardingData.length - 1
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                      : CircleBorder(),
                  padding: EdgeInsets.all(0),
                  backgroundColor: Colors.black,
                ),
                child: _currentPage == onboardingData.length - 1
                    ? Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Image.asset(
                        "assets/images/onboard_arrow.png",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class OnboardWidgets extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardWidgets({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 300,
        ),
        SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 50),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }
}

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String? gender;
  int? age;
  double? height;
  double? weight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 35, 35, 35),
              const Color.fromARGB(255, 0, 0, 0)
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Build Your Profile',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildDropdownField('Gender', ['Male', 'Female']),
                  SizedBox(height: 30),
                  _buildTextField('Age', 'years'),
                  SizedBox(height: 30),
                  _buildTextField('Height', 'cm'),
                  SizedBox(height: 30),
                  _buildTextField('Weight', 'kg'),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Start Tracking',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        value: gender,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            gender = value;
          });
        },
        validator: (value) {
          if (value == null) return 'Please select your gender';
          return null;
        },
      ),
    );
  }

  Widget _buildTextField(String label, String unit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
        onSaved: (value) {
          switch (label) {
            case 'Age':
              age = int.parse(value!);
              break;
            case 'Height':
              height = double.parse(value!);
              break;
            case 'Weight':
              weight = double.parse(value!);
              break;
          }
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrackingPage(
            gender: gender!,
            age: age!,
            height: height!,
            weight: weight!,
          ),
        ),
      );
    }
  }
}

class TrackingPage extends StatefulWidget {
  final String gender;
  final int age;
  final double height;
  final double weight;

  const TrackingPage({
    super.key,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  late DateTime _startTime;
  Duration _duration = Duration.zero;
  bool _isTracking = true;
  late Interpreter _vitalSignsInterpreter;
  late Interpreter _caloriesInterpreter;
  late Timer _predictionTimer;

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _loadModels();

    // Start a timer to update predictions every 20 seconds
    _predictionTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      if (_isTracking) {
        _updatePredictions();
      }
    });
  }

  Future<void> _loadModels() async {
    _vitalSignsInterpreter =
        await Interpreter.fromAsset('assets/Models/vital_signs_model.onnx');
    _caloriesInterpreter =
        await Interpreter.fromAsset('assets/Models/calories_model.onnx');
  }

  void _initPedometer() async {
    await Permission.activityRecognition.request();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      if (_isTracking) {
        setState(() {
          _steps = event.steps;
          _duration = DateTime.now().difference(_startTime);
        });
        _updatePredictions();
      }
    });
  }

  Future<void> _updatePredictions() async {
    var input = [
      widget.gender == 'Male' ? 1.0 : 0.0,
      widget.age.toDouble(),
      widget.height,
      widget.weight,
      _duration.inMinutes.toDouble(),
    ];

    var vitalSignsOutput = List<double>.filled(2, 0);
    _vitalSignsInterpreter.run(input, vitalSignsOutput);

    var caloriesInput = [...input, ...vitalSignsOutput];
    var caloriesOutput = List<double>.filled(1, 0);
    _caloriesInterpreter.run(caloriesInput, caloriesOutput);

    setState(() {
      _heartRate = vitalSignsOutput[0];
      _bodyTemp = vitalSignsOutput[1];
      _calories = caloriesOutput[0];
    });
  }

  double _heartRate = 0;
  double _bodyTemp = 0;
  double _calories = 0;

  @override
  void dispose() {
    _predictionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 35, 35, 35),
              const Color.fromARGB(255, 0, 0, 0)
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Steps, Miles & Burn',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _buildMetricCard(
                    'Steps', _steps.toString(), Icons.directions_walk),
                const SizedBox(height: 30),
                _buildMetricCard(
                  'Duration',
                  '${_duration.inMinutes}m ${_duration.inSeconds % 60}s',
                  Icons.timer,
                ),
                const SizedBox(height: 30),
                _buildMetricCard(
                  'Heart Rate',
                  '${_heartRate.toStringAsFixed(1)} bpm',
                  Icons.favorite,
                ),
                const SizedBox(height: 30),
                _buildMetricCard(
                  'Body Temperature',
                  '${_bodyTemp.toStringAsFixed(1)}°C',
                  Icons.thermostat,
                ),
                const SizedBox(height: 30),
                _buildMetricCard(
                  'Calories',
                  '${_calories.toStringAsFixed(1)} cal',
                  Icons.local_fire_department,
                ),
                const Spacer(),
                Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: const Color.fromARGB(255, 0, 0, 0)),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
