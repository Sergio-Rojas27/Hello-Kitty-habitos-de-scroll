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
      body: Stack(
        children: [
          // 1. La imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/f1.png'), // Asegúrate de tenerla en pubspec.yaml
                fit: BoxFit.fill, // Esto hace que la imagen llene toda la pantalla
              ),
            ),
          ),
          
          // 2. Tu contenido original encima
          SafeArea( // Agregamos SafeArea para que el contenido no choque con el notch
            child: Column(
    
      
              children: [
                
               Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/titulo.png'), // Asegúrate de tenerla en pubspec.yaml
                      fit: BoxFit.cover, // Esto hace que la imagen llene toda la pantalla
                    ),
                  ),
                ),
                const Spacer(),
                
                _buildMainButton(
                  context, 
                  'Comenzar', 
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()))
                ),
                const SizedBox(height: 20), // Un pequeño margen abajo
              ],
            ),
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
      // Quitamos el backgroundColor para que no tape la imagen
      body: Stack(
        children: [
          // 1. Capa del fondo: La imagen que ocupa todo
           Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/f2.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.5),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),

          
          // 2. Capa del contenido: El formulario con scroll
          SafeArea(
  child: Column(
    children: [
      // 1. El Header se queda fijo arriba
      _buildHeader(), 

      // 2. El contenido central (Inputs) con Scroll
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  '¡HOLA!',
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFFD6213B)
                  ),
                ),
                const Text('Inicia sesión para continuar', style: TextStyle(color: Color(0xFFD6213B),fontSize: 18, )),
                const SizedBox(height: 40),
                _inputField('Usuario', Icons.person_outline),
                const SizedBox(height: 20),
                _inputField('Contraseña', Icons.lock_outline, isPass: true),
                const SizedBox(height: 20), // Espacio extra para respirar
              ],
            ),
          ),
        ),
      ),

      // 3. El botón se queda FIJO ABAJO con su margen
      Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 30), // (Izquierda, Arriba, Derecha, Abajo)
        child: _buildMainButton(
          context, 
          'ENTRAR', 
          () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const RoleSelectionScreen())
          ),
        ),
      ),
    ],
  ),
)
        ], // Cierre de children del Stack
      ), // Cierre del Stack
    );
  }

  // Tu función _inputField está muy bien, solo asegúrate de que esté dentro de la clase
  Widget _inputField(String hint, IconData icon, {bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Tip: un toque de transparencia queda genial
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: TextField(
        obscureText: isPass ? _obscureText : false,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Color(0xFFD6213B)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
      body: Stack(
        children: [
          // 1. Fondo de imagen que cubre todo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/f2.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.5),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),

          // 2. Contenido de la pantalla
          SafeArea(
            child: Column(
    children: [
      _buildHeader(), // <-- Llamada limpia sin textos
      const SizedBox(height: 80),
      const Text(
        '¿Desea ingresar como niño\no como tutor?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          color: Color(0xFFD6213B),
        ),
      ),
      const Spacer(),// Empuja la selección al centro
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _roleCircle('Tutor', selectedRole == 'tutor', 
                      () => setState(() => selectedRole = 'tutor')),
                    const SizedBox(width: 30),
                    _roleCircle('Niño', selectedRole == 'niño', 
                      () => setState(() => selectedRole = 'niño')),
                  ],
                ),
                
                const Spacer(), // Empuja el botón hacia abajo

                // 3. BOTÓN INFERIOR CON MARGEN (Sin tocar el fondo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
                  child: ElevatedButton(
                    onPressed: selectedRole.isEmpty 
                      ? null 
                      : () {
                          if (selectedRole == 'tutor') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PinSecurityScreen()),
                            );
                          }
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD6213B),
                      disabledBackgroundColor: Colors.grey.shade400,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'CONTINUAR',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleCircle(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer( // Agregamos una pequeña animación al seleccionar
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFFD6213B) : Colors.grey, 
                width: 6,
              ),
              boxShadow: isSelected ? [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ] : [],
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: Icon(
                label == 'Tutor' ? Icons.settings_accessibility : Icons.child_care, 
                size: 50, 
                color: isSelected ? const Color(0xFFD6213B) : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFD6213B) : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS REUTILIZABLES (Para mantener el estilo) ---

Widget _buildHeader() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
    decoration: const BoxDecoration(
      color: Color(0xFFD6213B), // Tu rojo característico
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(60),
        bottomRight: Radius.circular(60),
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 10), // Espacio extra para que no pegue arriba
        Image.asset(
          'assets/titulo.png', // <--- Asegúrate de que la ruta sea correcta
          height: 80,       // Ajusta el tamaño según tu logo
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
// Widget _buildMainButton actualizado
Widget _buildMainButton(BuildContext context, String text, VoidCallback? onPressed) {
  return Padding(
    padding: const EdgeInsets.all(30.0),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // Fondo en el rojo RGB (214, 33, 59) especificado
        backgroundColor: const Color(0xFFD6213B), 
        minimumSize: const Size(double.infinity, 60),
        // Radio de borde más grande (30) para efecto de gomita
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5, // Mantenemos la sombra para profundidad
      ),
      child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
    ),
  );
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
    body: Stack(
      children: [
        // 1. Imagen de fondo con opacidad
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/f2.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5),
                BlendMode.dstATop,
              ),
            ),
          ),
        ),

        // 2. Contenido de la pantalla
        SafeArea(
          child: Column(
            children: [
              // Header arriba
              _buildSimpleHeader('ÁREA DE TUTOR', 'Ingresa tu PIN de seguridad'),
              
              // Este Spacer empuja el icono y el PIN al centro
              const Spacer(), 
              
              // Bloque Central: Icono y Campo de PIN
              Column(
                children: [
                  const Icon(Icons.lock_person, size: 80, color: Color(0xFFD6213B)),
                  const SizedBox(height: 30),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                      ],
                    ),
                    child: TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      style: const TextStyle(
                        fontSize: 30, 
                        letterSpacing: 20, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFFD6213B)
                      ),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: "••••",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),

              // Este Spacer empuja los botones al final de la pantalla
              const Spacer(), 

                            // Bloque Inferior: Botones pegados abajo
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0), // <--- El margen que buscas
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6213B),
                        minimumSize: const Size(double.infinity, 60), // Ocupa el ancho disponible menos el padding
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Continuar', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Color(0xFFD6213B), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // Header modificado con el color rojo especificado
  Widget _buildSimpleHeader(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      decoration: const BoxDecoration(
        color: Color(0xFFD6213B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60), 
          bottomRight: Radius.circular(60)
        ),
      ),
      child: Column(
        children: [
          Text(
            title, 
            style: const TextStyle(
              fontSize: 30, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
               // Rojo RGB 214, 33, 59
            )
          ),
          Text(
            subtitle, 
            style: const TextStyle(fontSize: 16, color: Colors.white)
          ),
        ],
      ),
    );
  }
}
