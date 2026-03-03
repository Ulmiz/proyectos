import 'package:flutter_test/flutter_test.dart';

// El import de tu proyecto (basado en el error que me mandaste, se llama flutter_application_2)
import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('Verificar que la app arranca y muestra el botón GET', (WidgetTester tester) async {
    // 1. Construimos nuestra app (¡Aquí es donde antes decía MyApp!)
    await tester.pumpWidget(const MiAppDeDescarga());

    // 2. Verificamos que el botón en su estado inicial muestra el texto 'GET'
    expect(find.text('GET'), findsOneWidget);
    
    // 3. Verificamos que no muestre el texto 'OPEN' todavía
    expect(find.text('OPEN'), findsNothing);
  });
}