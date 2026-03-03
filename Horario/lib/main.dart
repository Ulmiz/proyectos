import 'package:flutter/material.dart';

void main() => runApp(const MiHorarioApp());

class MiHorarioApp extends StatelessWidget {
  const MiHorarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HorarioScreen(),
    );
  }
}

class Materia {
  final String nombre;
  final String clave;
  final String docente;
  final String horario;
  final String salon;
  final Color color;
  final String dia;

  Materia({
    required this.nombre,
    required this.clave,
    required this.docente,
    required this.horario,
    required this.salon,
    required this.color,
    required this.dia,
  });
}

class HorarioScreen extends StatelessWidget {
  const HorarioScreen({super.key});

  // Lista de materias actualizada con Desarrollo Móvil
  List<Materia> get materias => [
    Materia(
      nombre: "INTELIGENCIA ARTIF.",
      clave: "SCC1012 8SC",
      docente: "LARISSA JEANETTE PENICHE",
      horario: "14:00 - 16:00",
      salon: "GP1",
      color: Colors.blueAccent,
      dia: "Lunes",
    ),
    Materia(
      nombre: "ADMIN. DE REDES",
      clave: "SCA1002 8SC",
      docente: "BRAULIO AZAAF PAZ GARCIA",
      horario: "16:00 - 18:00",
      salon: "HP2",
      color: Colors.orangeAccent,
      dia: "Lunes",
    ),
    Materia(
      nombre: "TALLER DE INV. I",
      clave: "ACA0909 8SA",
      docente: "PEDRO ALFONSO GUADALUPE",
      horario: "12:00 - 14:00",
      salon: "H6",
      color: Colors.greenAccent,
      dia: "Martes",
    ),
    Materia(
      nombre: "PROGR.APLIC.MOV.",
      clave: "DWB2402 8SC",
      docente: "SARA NELLY MORENO CIMÉ",
      horario: "14:00 - 17:00",
      salon: "HP2",
      color: Colors.redAccent,
      dia: "Martes",
    ),
    Materia(
      nombre: "DES BACK-END",
      clave: "DWB2401 8SC",
      docente: "RODRIGO FIDEL GAXIOLA SO",
      horario: "09:00 - 11:00",
      salon: "H8",
      color: Colors.purpleAccent,
      dia: "Miércoles",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Horario Escolar", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: materias.length,
        itemBuilder: (context, index) {
          final materia = materias[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: VerticalDivider(color: materia.color, thickness: 4),
              title: Text(materia.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${materia.dia} | ${materia.horario}\nAula: ${materia.salon}"),
              trailing: const Icon(Icons.info_outline, color: Colors.indigo),
              onTap: () => _mostrarDetalleMaestro(context, materia),
            ),
          );
        },
      ),
    );
  }

  void _mostrarDetalleMaestro(BuildContext context, Materia materia) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Corregido para evitar desbordamiento
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajuste automático de altura
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 35,
                backgroundColor: materia.color.withValues(alpha: 0.2), // Corrección de advertencia
                child: Icon(Icons.person, size: 35, color: materia.color),
              ),
              const SizedBox(height: 15),
              const Text("Docente Asignado", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(
                materia.docente,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 30),
              Row(
                children: [
                  const Icon(Icons.book, size: 20, color: Colors.indigo),
                  const SizedBox(width: 10),
                  Expanded(child: Text("Materia: ${materia.nombre}")),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.fingerprint, size: 20, color: Colors.indigo),
                  const SizedBox(width: 10),
                  Text("Clave: ${materia.clave}"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}