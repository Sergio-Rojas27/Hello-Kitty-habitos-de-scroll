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
                const SizedBox(height: 20), 
                
                // --- NUEVO CÓDIGO: Enlace a la pantalla de registro ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes cuenta? ',
                      style: TextStyle(color: Color(0xFFD6213B), fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navegación hacia la pantalla de registro
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const RegisterScreen())
                        );
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Color(0xFFD6213B),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline, // Subrayado para indicar que es un enlace
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Espacio extra para respirar
                // --------------------------------------------------------
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Variables independientes para mostrar/ocultar contraseñas y pines
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscurePin = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // 1. El Header fijo arriba 
                _buildHeader(), 

                // 2. El contenido central (Inputs) con Scroll
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            '¡ÚNETE!',
                            style: TextStyle(
                              fontSize: 28, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xFFD6213B)
                            ),
                          ),
                          const Text(
                            'Crea tu cuenta para empezar', 
                            style: TextStyle(
                              color: Color(0xFFD6213B),
                              fontSize: 18, 
                            ),
                          ),
                          const SizedBox(height: 25),

                          // --- 2 FOTOS DE PERFIL (Tutor y Niño) ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildProfilePicPicker('Tutor', Icons.person),
                              _buildProfilePicPicker('Niño', Icons.child_care),
                            ],
                          ),
                          const SizedBox(height: 25),
                          
                          // --- CAMPOS DE REGISTRO ---
                          _inputField(
                            hint: 'Nombre del Tutor', 
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 15),

                          _inputField(
                            hint: 'Nombre del Niño', 
                            icon: Icons.child_care, 
                          ),
                          const SizedBox(height: 15),
                          
                          _inputField(
                            hint: 'Correo Electrónico', 
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress, 
                          ),
                          const SizedBox(height: 15),

                          _inputField(
                            hint: 'PIN del Tutor (4 dígitos)', 
                            icon: Icons.dialpad, 
                            isPass: true,
                            obscureValue: _obscurePin,
                            keyboardType: TextInputType.number, 
                            onToggleVisibility: () {
                              setState(() => _obscurePin = !_obscurePin);
                            }
                          ),
                          const SizedBox(height: 15),
                          
                          _inputField(
                            hint: 'Contraseña', 
                            icon: Icons.lock_outline, 
                            isPass: true,
                            obscureValue: _obscurePassword,
                            onToggleVisibility: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            }
                          ),
                          const SizedBox(height: 15),

                          _inputField(
                            hint: 'Confirmar Contraseña', 
                            icon: Icons.lock_outline, 
                            isPass: true,
                            obscureValue: _obscureConfirmPassword,
                            onToggleVisibility: () {
                              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                            }
                          ),
                          const SizedBox(height: 20), 
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Botón principal y Texto de redirección al Login
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 30), 
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ajusta la columna al tamaño de sus hijos
                    children: [
                      // Botón principal ocupa todo el ancho
                      ElevatedButton(
                        onPressed: () {
                          // Aquí iría la lógica para registrar todo
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD6213B), 
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'REGISTRARSE', 
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // --- NUEVO TEXTO: ¿Ya tienes cuenta? ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿Ya tienes una cuenta? ',
                            style: TextStyle(color: Color(0xFFD6213B), fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Esto cierra la pantalla de Registro y vuelve al Login
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Inicia sesión',
                              style: TextStyle(
                                color: Color(0xFFD6213B),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline, // Subrayado interactivo
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ], 
      ), 
    );
  }

  // --- WIDGET PARA SELECCIONAR FOTO DE PERFIL ---
  Widget _buildProfilePicPicker(String label, IconData defaultIcon) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print("Seleccionar imagen de perfil para $label");
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4), 
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                child: CircleAvatar(
                  radius: 40, 
                  backgroundColor: Colors.white,
                  child: Icon(defaultIcon, size: 45, color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFD6213B),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt, 
                  color: Colors.white, 
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD6213B),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // --- WIDGET INPUT FIELD A PRUEBA DE ERRORES (NULL-SAFE) ---
  Widget _inputField({
    required String hint, 
    required IconData icon, 
    bool? isPass,          
    bool? obscureValue,    
    TextInputType? keyboardType, 
    VoidCallback? onToggleVisibility,
  }) {
    final bool isPassword = isPass ?? false;
    final bool hideText = obscureValue ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), 
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: TextField(
        obscureText: isPassword ? hideText : false,
        keyboardType: keyboardType ?? TextInputType.text, 
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFFD6213B)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(
                  hideText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onToggleVisibility,
              ) 
            : null,
        ),
      ),
    );
  }

  // Tu Header reutilizable
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFD6213B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Image.asset(
            'assets/titulo.png',
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 5),
        ],
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
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0), 
                child: Column(
                  children: [
                    ElevatedButton(
                      // --- MAGIA AÑADIDA AQUÍ ---
                      onPressed: () {
                        // Navegamos al Dashboard del Tutor y evitamos que vuelva atrás con el botón del celular
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TutorDashboardScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6213B),
                        minimumSize: const Size(double.infinity, 60), 
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

class TutorDashboardScreen extends StatelessWidget {
  const TutorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Un fondo rosa súper clarito para dar la vibra de Sanrio sin cansar la vista
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F6), 
      body: Column(
        children: [
          // 1. HEADER (Top Bar redondeada)
          _buildTopHeader(),

          const SizedBox(height: 20),

          
          const SizedBox(height: 20),

          // 3. BOTONES DEL MENÚ (Basados en los Casos de Uso)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                _buildMenuButton(
                  title: 'Asignar nuevas tareas',
                  icon: Icons.add_task,
                  onTap: () {
                    // Navegar a la pantalla de crear tarea
                  },
                ),
                _buildMenuButton(
                  title: 'Validar tareas completadas',
                  icon: Icons.check_circle_outline,
                  onTap: () {
                    // Navegar a la pantalla de validación
                  },
                ),
                _buildMenuButton(
                  title: 'Ver informes y progreso',
                  icon: Icons.bar_chart_rounded,
                  onTap: () {
                    // Navegar a los reportes
                  },
                ),
                _buildMenuButton(
                  title: 'Establecer recompensas',
                  icon: Icons.card_giftcard_rounded,
                  onTap: () {
                    // Navegar a la configuración de premios
                  },
                ),
              ],
            ),
          ),

          // 4. BOTTOM NAVIGATION BAR (Barra inferior)
          _buildBottomNav(),
        ],
      ),
    );
  }

  // --- WIDGET: HEADER SUPERIOR ---
  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar y Nivel/Nombre
          Row(
            children: [
              // Avatar con el "Badge" (Etiqueta) de Tutor
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD6213B),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      // backgroundImage: AssetImage('assets/tutor_avatar.png'), 
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB703), // Amarillo dorado
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Text(
                        'Tutor',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              // Textos (Nombre, Nivel, Puntos)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mamá / Papá', // Aquí iría el nombre dinámico
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD6213B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        'Nivel 1',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Pildorita de puntos
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB703),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.stars, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '235pts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Ícono de acción derecho (Ej: Cofre o Ajustes)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.settings, // Cambia por un asset de cofre si lo tienes
              color: Color(0xFFD6213B),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: BOTÓN DEL MENÚ ---
  Widget _buildMenuButton({required String title, required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFD6213B), size: 28),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET: BARRA INFERIOR ---
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(Icons.home_rounded, true),
          _navItem(Icons.list_alt_rounded, false),
          _navItem(Icons.person_outline, false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 32,
          color: isActive ? const Color(0xFFD6213B) : Colors.grey.shade400,
        ),
        if (isActive)
          Container(
          
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFD6213B),
              shape: BoxShape.circle,
            ),
          )
      ],
    );
  }
}
