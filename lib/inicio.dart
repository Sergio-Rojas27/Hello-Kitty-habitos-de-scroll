import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isLoading = false; // Para el estado de carga

  // CONTROLADORES: Capturan el texto de los inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // FUNCIÓN PARA CONECTAR A LARAGON
  Future<void> _loginConLaragon() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _mostrarMensaje("Por favor, llena todos los campos");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Si usas Chrome en Laragon:
      // USA TU IP REAL EN LUGAR DE LOCALHOST
      var url = Uri.parse('http://192.168.0.167/api_hk/login.php');

      var response = await http.post(url, body: {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Esto va dentro de tu lógica de Login exitoso
        if (data['status'] == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PinSecurityScreen(
                usuarioId: data['id'].toString(), // Pasamos el ID que devolvió el login.php
              ),
            ),
          );
        }
        if (data['status'] == 'success') {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              // 1. Quita el 'const'
        // 2. Pasa el usuarioId (asumiendo que 'data' es la respuesta de tu login.php)
        MaterialPageRoute(
          builder: (context) => RoleSelectionScreen(
            usuarioId: data['id'].toString(), 
          ),
        ),
                    );
                  }
                } else {
                  _mostrarMensaje(data['message']);
                }
              }
            } catch (e) {
              _mostrarMensaje("Error de conexión con Laragon");
            } finally {
              if (mounted) setState(() => _isLoading = false);
            }
          }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: const Color(0xFFD6213B)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Capa del fondo
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
          
          // 2. Contenido
          SafeArea(
            child: Column(
              children: [
                _buildHeader(), // Asegúrate de tener esta función definida abajo
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          const Text('¡HOLA!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFD6213B))),
                          const Text('Inicia sesión para continuar', style: TextStyle(color: Color(0xFFD6213B), fontSize: 18)),
                          const SizedBox(height: 40),
                          
                          // Pasamos los controladores a los campos
                          _inputField('Usuario', Icons.person_outline, controller: _emailController),
                          const SizedBox(height: 20),
                          _inputField('Contraseña', Icons.lock_outline, isPass: true, controller: _passwordController),
                          
                          const SizedBox(height: 20),
                          _buildRegisterLink(),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Botón FIJO ABAJO
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Color(0xFFD6213B)) 
                    : _buildMainButton(context, 'ENTRAR', _loginConLaragon),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE APOYO ACTUALIZADOS ---

  Widget _inputField(String hint, IconData icon, {bool isPass = false, required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: TextField(
        controller: controller, // Vinculamos el controlador
        obscureText: isPass ? _obscureText : false,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFFD6213B)),
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

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿No tienes cuenta? ', style: TextStyle(color: Color(0xFFD6213B), fontSize: 15)),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
          child: const Text('Regístrate', style: TextStyle(color: Color(0xFFD6213B), fontSize: 15, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
        ),
      ],
    );
  }
}

// --- 3. ROLE SELECTION SCREEN ---
class RoleSelectionScreen extends StatefulWidget {
  final String usuarioId; // <--- Agrega esto

  const RoleSelectionScreen({super.key, required this.usuarioId}); // <--- Actualiza el constructor

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
                            MaterialPageRoute(
                              builder: (context) => PinSecurityScreen(
                                usuarioId: widget.usuarioId, // <--- CAMBIO AQUÍ: Usamos el ID que recibió la pantalla
                              ),
                            ),
                          );
                        } else {
                          // Lógica para el rol de niño si es necesario
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
  final String usuarioId; // <-- Agregamos esto

  const PinSecurityScreen({super.key, required this.usuarioId}); // Constructor actualizado

  @override
  State<PinSecurityScreen> createState() => _PinSecurityScreenState();
}
class _PinSecurityScreenState extends State<PinSecurityScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;

Future<void> _verifyPin() async {
  if (_pinController.text.length < 4) return;

  setState(() => _isLoading = true);

  try {
    final response = await http.post(
      Uri.parse('http://192.168.0.167/api_hk/verify_pin.php'),
      body: {
        'id_usuario': widget.usuarioId, // <-- USA EL ID REAL QUE VIENE DEL LOGIN
        'pin': _pinController.text,
      },
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      if (!mounted) return;
      
      // Navegamos al Dashboard pasando el nombre que nos dio el PHP
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TutorDashboardScreen(
            nombreTutor: data['nombre_tutor'], 
          ),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN Incorrecto'), backgroundColor: Colors.red),
      );
      _pinController.clear();
    }
  } catch (e) {
    print("Error de conexión: $e");
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

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
                      onPressed: _isLoading ? null : _verifyPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6213B),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Continuar', 
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                    ),

                    const SizedBox(height: 10), // Espacio entre botones

                    // 2. EL BOTÓN DE CANCELAR (TextButton para que sea secundario)
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xFFD6213B), 
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
  final String nombreTutor; // <-- Agregamos esta variable

  const TutorDashboardScreen({
    super.key, 
    this.nombreTutor = 'Tutor' // Valor por defecto por si acaso
  });
  

  @override
  Widget build(BuildContext context) {
    // Un fondo rosa súper clarito para dar la vibra de Sanrio sin cansar la vista
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F6), 
      body: Column(
        children: [
          // 1. HEADER (Top Bar redondeada)
          _buildTopHeader(context),

          const SizedBox(height: 20),
          
          const SizedBox(height: 10),
          Image.asset(
            'assets/titulo.png',
            height: 70,
            fit: BoxFit.contain,
          ),
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
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 35), // Aumenté un poco el 'top' para que no choque con la barra de estado del teléfono
      decoration: const BoxDecoration(
        color: Color(0xFFD6213B), // Fondo rojo principal
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40D6213B), // Sombra del mismo tono rojo pero más suave
            blurRadius: 20, 
            offset: Offset(0, 8)
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sección Izquierda: Avatar y Textos
          Expanded( // Usamos Expanded para evitar que textos muy largos rompan el diseño
            child: Row(
              children: [
                // Avatar con el "Badge" (Etiqueta) de Tutor
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4), // Borde blanco un poco más grueso
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
                        ]
                      ),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xFFFFF5F6), // Un rosita muy suave de fondo
                        // backgroundImage: AssetImage('assets/tutor_avatar.png'), 
                        child: Icon(Icons.person_outline_rounded, size: 40, color: Color(0xFFD6213B)), // Ícono rojo para contrastar
                      ),
                    ),
                    Positioned(
                      bottom: -12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFFBE750), // Amarillo dorado
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 2.5), // Borde más pronunciado
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                          ]
                        ),
                        
                          child: const Text(
                          'Tutor',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900, // Letra más gruesa
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                
                // Textos (Nombre, Nivel, Puntos)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          nombreTutor, // <-- Usamos la variable aquí
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2), // Fondo translúcido en vez de texto gris
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Nivel 1',
                              style: TextStyle(
                                color: Colors.white, // Blanco para que se lea sobre el rojo
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Pildorita de puntos
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFFFBE750),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                              ]
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.stars_rounded, color: Colors.white, size: 16), // Ícono más redondo
                                SizedBox(width: 4),
                                Text(
                                  '235 pts',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 15),

          // Ícono de acción derecho (Ajustes)
          // Ícono de acción derecho (Ajustes)
          GestureDetector(
            onTap: () {
              // Navegar a la pantalla de configuración
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.settings_rounded, 
                color: Colors.white, 
                size: 28,
              ),
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
      decoration: const BoxDecoration(
        color:  Color(0xFFD6213B),
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
          _navItem(Icons.amp_stories_rounded, false),
        ],
      ),
    );
  }

Widget _navItem(IconData icon, bool isActive) {
    return Container(
      // Le damos un tamaño un poco mayor al ícono (32) para que el círculo se vea bien
      width: 50, 
      height: 50,
      decoration: BoxDecoration(
        // Si está activo el fondo es blanco, si no, es transparente
        color: isActive ? Colors.white : Colors.transparent, 
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: 32,
          // Si está activo el ícono es rojo, si no, es blanco
          color: isActive ? const Color(0xFFD6213B) : Colors.white,
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
  // --- CONTROLADORES PARA LOS INPUTS ---
  final TextEditingController _tutorNameCtrl = TextEditingController();
  final TextEditingController _childNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pinCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();

  // --- VARIABLES PARA CONTRASEÑAS ---
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscurePin = true;

  // --- VARIABLES PARA LAS IMÁGENES ---
  File? _tutorImage;
  File? _childImage;

  // --- FUNCIÓN PARA SELECCIONAR FOTO ---
  Future<void> _pickImage(bool isTutor) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isTutor) {
          _tutorImage = File(pickedFile.path);
        } else {
          _childImage = File(pickedFile.path);
        }
      });
    }
  }

  // --- FUNCIÓN PARA ENVIAR DATOS AL BACKEND ---
  // --- FUNCIÓN PARA ENVIAR DATOS AL BACKEND CORREGIDA ---
  Future<void> _registerUser() async {
  // 1. Validaciones básicas
  if (_passwordCtrl.text != _confirmPassCtrl.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Las contraseñas no coinciden'), 
        backgroundColor: Color(0xFFD6213B),
      ),
    );
    return;
  }

  // 2. Usaremos un POST normal para asegurar la recepción de datos
  // IMPORTANTE: Asegúrate de que la IP de tu PC siga siendo 192.168.0.167
  var url = Uri.parse('http://192.168.0.167/api_hk/register.php');

  try {
    // Si NO vas a enviar fotos por ahora, usa este formato:
    var response = await http.post(
      url,
      body: {
        'nombre_tutor': _tutorNameCtrl.text.trim(),
        'nombre_nino': _childNameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'pin': _pinCtrl.text.trim(),
        'password': _passwordCtrl.text,
      },
    );

    print("Respuesta del servidor: ${response.body}");

    if (response.statusCode == 200) {
      // Intentar decodificar la respuesta del PHP
      final result = jsonDecode(response.body);
      
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Registro exitoso!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        // Aquí verás el error detallado que enviamos desde el PHP
        print("Error del PHP: ${result['message']}");
      }
    } else {
      print('Error en el servidor HTTP: ${response.statusCode}');
    }
  } catch (e) {
    print('Error de conexión: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Capa del fondo
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

          // 2. Capa del contenido
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
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
                                color: Color(0xFFD6213B)),
                          ),
                          const Text(
                            'Crea tu cuenta para empezar',
                            style: TextStyle(
                              color: Color(0xFFD6213B),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // --- 2 FOTOS DE PERFIL ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildProfilePicPicker('Tutor', Icons.person, true),
                              _buildProfilePicPicker('Niño', Icons.child_care, false),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // --- CAMPOS DE REGISTRO ---
                          _inputField(
                            hint: 'Nombre del Tutor',
                            icon: Icons.person_outline,
                            controller: _tutorNameCtrl,
                          ),
                          const SizedBox(height: 15),

                          _inputField(
                            hint: 'Nombre del Niño',
                            icon: Icons.child_care,
                            controller: _childNameCtrl,
                          ),
                          const SizedBox(height: 15),

                          _inputField(
                            hint: 'Correo Electrónico',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailCtrl,
                          ),
                          const SizedBox(height: 15),

                          _inputField(
                            hint: 'PIN del Tutor (4 dígitos)',
                            icon: Icons.dialpad,
                            isPass: true,
                            obscureValue: _obscurePin,
                            keyboardType: TextInputType.number,
                            controller: _pinCtrl,
                            onToggleVisibility: () {
                              setState(() => _obscurePin = !_obscurePin);
                            },
                          ),
                          const SizedBox(height: 15),

                          _inputField(
                            hint: 'Contraseña',
                            icon: Icons.lock_outline,
                            isPass: true,
                            obscureValue: _obscurePassword,
                            controller: _passwordCtrl,
                            onToggleVisibility: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          const SizedBox(height: 15),

                          _inputField(
                            hint: 'Confirmar Contraseña',
                            icon: Icons.lock_outline,
                            isPass: true,
                            obscureValue: _obscureConfirmPassword,
                            controller: _confirmPassCtrl,
                            onToggleVisibility: () {
                              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Botón principal
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: _registerUser, // <--- LLAMA A LA FUNCIÓN AQUÍ
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD6213B),
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                        child: const Text(
                          'REGISTRARSE',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿Ya tienes una cuenta? ',
                            style: TextStyle(color: Color(0xFFD6213B), fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Inicia sesión',
                              style: TextStyle(
                                color: Color(0xFFD6213B),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
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

  // --- WIDGET ACTUALIZADO PARA SELECCIONAR FOTO ---
  Widget _buildProfilePicPicker(String label, IconData defaultIcon, bool isTutor) {
    // Determina qué archivo mostrar dependiendo si es tutor o niño
    File? currentImage = isTutor ? _tutorImage : _childImage;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(isTutor),
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
                  // Muestra la imagen si existe, o el ícono por defecto
                  backgroundImage: currentImage != null ? FileImage(currentImage) : null,
                  child: currentImage == null
                      ? Icon(defaultIcon, size: 45, color: Colors.grey)
                      : null,
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
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
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

  // --- WIDGET INPUT FIELD ACTUALIZADO CON CONTROLADOR ---
  Widget _inputField({
    required String hint,
    required IconData icon,
    TextEditingController? controller, // <--- SE AGREGA ESTO
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
        controller: controller, // <--- SE ASIGNA AQUÍ
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
          Image.asset('assets/titulo.png', height: 60, fit: BoxFit.contain),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}




















class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F6), // Fondo rosita de Hello Kitty
      body: Column(
        children: [
          // 1. HEADER (Top Bar)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 35),
            decoration: const BoxDecoration(
              color: Color(0xFFD6213B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(color: Color(0x40D6213B), blurRadius: 20, offset: Offset(0, 8))
              ],
            ),
            child: Row(
              children: [
                // Botón de regresar
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  'Configuración',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // 2. OPCIONES DE LA CUENTA
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                // Título de sección
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 15),
                  child: Text(
                    'Mi Cuenta',
                    style: TextStyle(
                      color: Color(0xFFD6213B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // Botón: Editar Cuenta
                _buildSettingsOption(
                  title: 'Editar cuenta',
                  subtitle: 'Modifica tu nombre, correo o avatar',
                  icon: Icons.edit_rounded,
                  onTap: () {
                    // Aquí iría la lógica o navegación para editar
                  },
                ),
                
                // Botón Extra: Cambiar PIN de Seguridad (Ideal para el Tutor)
                _buildSettingsOption(
                  title: 'Privacidad y Seguridad',
                  subtitle: 'Cambia tu PIN de seguridad',
                  icon: Icons.lock_rounded,
                  onTap: () {
                    // Navegar a cambiar PIN
                  },
                ),

                // Botón: Borrar Cuenta (Zona de Peligro)
                _buildDeleteAccountOption(context),
              ],
            ),
          ),

          // 3. BOTTOM NAVIGATION BAR AÑADIDO AQUÍ
          _buildBottomNav(context),
        ],
      ),
    );
  }

  // --- WIDGET REUTILIZABLE PARA OPCIONES NORMALES ---
  Widget _buildSettingsOption({
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required VoidCallback onTap
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F6), // Fondo rosita
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: const Color(0xFFD6213B), size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET ESPECIAL PARA BORRAR CUENTA ---
  Widget _buildDeleteAccountOption(BuildContext context) {
    return InkWell(
      onTap: () {
        // Muestra un modal emergente para confirmar
        _showDeleteConfirmation(context);
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.red.shade200, width: 2), // Borde rojo tenue para indicar advertencia
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 28),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Borrar cuenta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Esta acción no se puede deshacer',
                    style: TextStyle(fontSize: 13, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para mostrar una ventana de advertencia antes de borrar
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: const Text('¿Estás seguro?', style: TextStyle(color: Color(0xFFD6213B), fontWeight: FontWeight.bold)),
          content: const Text('Si borras tu cuenta, se perderán todos los avances, puntos y tareas del niño. Esta acción es permanente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cierra el diálogo
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí va la lógica de backend para borrar la cuenta
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Sí, borrar cuenta', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- WIDGET: BARRA INFERIOR ---
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
      decoration: const BoxDecoration(
        color: Color(0xFFD6213B),
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
          // Al tocar "Home", regresamos al Dashboard original
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: _navItem(Icons.home_rounded, false),
          ),
          _navItem(Icons.list_alt_rounded, false),
          // El tercer ícono indica el menú de perfil/cuenta, por lo que está activo
          _navItem(Icons.amp_stories_rounded, false), 
        ],
      ),
    );
  }

  // Elemento individual del Navbar
  Widget _navItem(IconData icon, bool isActive) {
    return Container(
      width: 50, 
      height: 50,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent, 
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: 32,
          color: isActive ? const Color(0xFFD6213B) : Colors.white,
        ),
      ),
    );
  }
}