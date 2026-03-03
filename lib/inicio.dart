import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello Kitty App',
      theme: ThemeData(fontFamily: 'Arial'),
      home: const LandingScreen(), // Punto de partida
    );
  }
}

// --- 1. LANDING PAGE ---
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader('Hello Kitty:', 'My little world & habits'),
          const Spacer(),
          const Icon(Icons.auto_awesome, size: 120, color: Color(0xFFFFD54F)),
          const Spacer(),
          _buildMainButton(
            context, 
            'COMENZAR', 
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()))
          ),
        ],
      ),
    );
  }
}

// --- 2. LOGIN SCREEN (NUEVA) ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader('¡HOLA!', 'Inicia sesión para continuar'),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _inputField('Usuario', Icons.person_outline),
                  const SizedBox(height: 20),
                  _inputField('Contraseña', Icons.lock_outline, isPass: true),
                  const SizedBox(height: 40),
                  _buildMainButton(
                    context, 
                    'ENTRAR', 
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RoleSelectionScreen()))
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint, IconData icon, {bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: TextField(
        obscureText: isPass ? _obscureText : false,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFFFFD54F)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          suffixIcon: isPass ? IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ) : null,
        ),
      ),
    );
  }
}

// --- 3. ROLE SELECTION SCREEN ---
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader('DAVE\'S', 'KINGDOM'),
          const SizedBox(height: 40),
          const Text('¿Desea ingresar como niño\no como tutor?', 
            textAlign: TextAlign.center, 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roleCircle('Tutor', selectedRole == 'tutor', () => setState(() => selectedRole = 'tutor')),
              const SizedBox(width: 30),
              _roleCircle('Niño', selectedRole == 'niño', () => setState(() => selectedRole = 'niño')),
            ],
          ),
          const Spacer(),
          _buildMainButton(context, 'CONTINUAR', selectedRole.isEmpty ? null : () {
            if (selectedRole == 'niño') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KidMapScreen()),
              );
            } else {
              // Aquí podrías enviar a la pantalla de Tutor si la tienes
              // Pide el PIN antes de entrar
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const PinSecurityScreen())
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _roleCircle(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFD54F), width: 6),
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: isSelected ? const Color(0xFFFFD54F).withOpacity(0.4) : Colors.white,
              child: Icon(Icons.person, size: 40, color: isSelected ? Colors.orange : Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFFFD54F), borderRadius: BorderRadius.circular(15)),
            child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS REUTILIZABLES (Para mantener el estilo) ---

Widget _buildHeader(String title, String subtitle) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
    ),
    child: Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xFFFFD54F))),
        Text(subtitle, style: const TextStyle(fontSize: 20, color: Color(0xFFFFD54F), fontWeight: FontWeight.w500), textAlign: TextAlign.center),
      ],
    ),
  );
}

Widget _buildMainButton(BuildContext context, String text, VoidCallback? onPressed) {
  return Padding(
    padding: const EdgeInsets.all(30.0),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD54F),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
      child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
    ),
  );
}

class KidMapScreen extends StatelessWidget {
  const KidMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // --- Header de Perfil ---
            _buildProfileHeader(),

            // --- Mapa de Reinos (Scrollable) ---
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Línea vertical amarilla de fondo
                  Container(width: 8, color: const Color(0xFFFFD54F)),
                  
                  ListView(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    children: [
                      _buildKingdomLevel(
                        level: "1",
                        name: "Reino 1",
                        image: Icons.home_work_outlined, // Reemplazar por tu asset de casa
                        isLeft: true,
                      ),
                      _buildKingdomLevel(
                        level: "2",
                        name: "Reino 2",
                        image: Icons.fort_outlined, // Reemplazar por tu asset de castillo 1
                        isLeft: false,
                      ),
                      _buildKingdomLevel(
                        level: "3",
                        name: "Reino 3",
                        image: Icons.castle_outlined, // Reemplazar por tu asset de castillo 2
                        isLeft: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- Bottom Navigation Bar ---
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // Widget del Header
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Color(0xFFFFD54F),
            child: CircleAvatar(radius: 31, backgroundColor: Colors.white, child: Icon(Icons.face, size: 40)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Maria Castillo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD54F))),
                Row(
                  children: [
                    const Text('Nivel 1', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFD54F), borderRadius: BorderRadius.circular(20)),
                      child: const Text('⭐ 235pts', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.inventory_2_outlined, size: 40, color: Colors.brown),
        ],
      ),
    );
  }

  // Widget para cada nivel del mapa
  Widget _buildKingdomLevel({required String level, required String name, required IconData image, required bool isLeft}) {
    Widget kingdomInfo = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isLeft) const SizedBox(width: 20),
        Icon(image, size: 80, color: Colors.black87),
        if (isLeft) const SizedBox(width: 20),
        Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lado izquierdo
          Expanded(child: isLeft ? Align(alignment: Alignment.centerRight, child: kingdomInfo) : const SizedBox()),
          
          // Círculo del número
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFD54F), boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)]),
            child: Center(child: Text(level, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),

          // Lado derecho
          Expanded(child: !isLeft ? Align(alignment: Alignment.centerLeft, child: kingdomInfo) : const SizedBox()),
        ],
      ),
    );
  }

  // Widget del menú inferior
  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.description_outlined, size: 35, color: Colors.orange),
          Icon(Icons.fort_outlined, size: 35, color: Colors.grey),
          Icon(Icons.menu_book_outlined, size: 35, color: Colors.redAccent),
        ],
      ),
    );
  }
}

class PinSecurityScreen extends StatefulWidget {
  const PinSecurityScreen({super.key});

  @override
  State<PinSecurityScreen> createState() => _PinSecurityScreenState();
}

class _PinSecurityScreenState extends State<PinSecurityScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header consistente
          _buildSimpleHeader('ÁREA DE TUTOR', 'Ingresa tu PIN de seguridad'),
          
          const Spacer(),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const Icon(Icons.lock_person, size: 80, color: Color(0xFFFFD54F)),
                const SizedBox(height: 30),
                
                // Campo de PIN
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    style: const TextStyle(fontSize: 30, letterSpacing: 20, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: "••••",
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Botón Continuar (Estilo Dave's Kingdom)
                ElevatedButton(
                  onPressed: () {
                    if (_pinController.text.length == 4) {
                      // Redirigir al área de Tutor
                      Navigator.pushReplacement( // Usamos pushReplacement para que no pueda volver al PIN con el botón de atrás
                        context,
                        MaterialPageRoute(builder: (context) => const TutorDashboardScreen()),
                      );
                    } else {
                      // Opcional: Mostrar error si el PIN está incompleto
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ingresa un PIN de 4 dígitos')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54F),
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Continuar', style: TextStyle(fontSize: 22, color: Colors.white)),
                ),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          ),
          
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildSimpleHeader(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFFFFD54F))),
          Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

class TutorDashboardScreen extends StatelessWidget {
  const TutorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // --- Header de Perfil (Silvia Bieber) ---
            _buildTutorHeader(),

            const SizedBox(height: 20),

            // --- Título Central ---
            const Text(
              'DAVE\'S',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD54F),
                letterSpacing: 2,
              ),
            ),
            const Text(
              'KINGDOM',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD54F),
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 30),

            // --- Lista de Opciones ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                children: [
                  _buildMenuButton('Administrar usuarios', () {}),
                  _buildMenuButton('Ver informes y progreso', () {}),
                  _buildMenuButton('Asignar tareas', () {}),
                  _buildMenuButton('Establecer recompensas', () {}),
                ],
              ),
            ),

            // --- Bottom Navigation Bar ---
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // Header con la info de la Tutora
  Widget _buildTutorHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor: Color(0xFFFFD54F),
            child: CircleAvatar(
              radius: 34,
              backgroundColor: Colors.white,
              child: Icon(Icons.face_retouching_natural, size: 45, color: Colors.purple), 
              // ^ Aquí iría la imagen de Silvia Bieber
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Silvia Bieber',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD54F)),
                ),
                Row(
                  children: [
                    const Text('Nivel 1', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('⭐ 235pts', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.card_giftcard, size: 40, color: Colors.brown), // Icono del cofre
        ],
      ),
    );
  }

  // Botones del menú
  Widget _buildMenuButton(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  // Menu inferior
  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.description_outlined, size: 35, color: Colors.orange),
          Icon(Icons.fort_outlined, size: 35, color: Colors.grey),
          Icon(Icons.menu_book_outlined, size: 35, color: Colors.redAccent),
        ],
      ),
    );
  }
}