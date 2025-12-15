<img src="assets/images/ic_launcher-web.png" width="100" />

# Servicio técnico

<!-- <img src="assets/images/screenshot.png" heigth="500" style="margin-bottom: 1rem" /> -->

Aplicación hecha en Flutter generar presupuestos sencillos. Incorpora detalles del cliente y lista cada ítem del presupuesto.

# Screenshots

# Características
- Guarda los ultimos 5 presupuestos.
- Se puede cargar en el presupuesto el **numero de contacto para contactarse por Whatsapp** si asi se requiere.
- Se puede exportar los presupuestos como **Imagen** (para compartir) o guardar como **PDF**.
- Se puede configurar una **imagen como pie de página** para mostrar en el PDF.

# Librerías utilizadas
- _flutter_riverpod_: Gestiona el estado de la aplicación de manera eficiente y escalable.
- _provider_: Complementa Riverpod para la inyección de dependencias y gestión de estado.
- _pdf_: Genera y manipula archivos PDF directamente desde la aplicación.
- _image_picker_: Permite seleccionar imágenes desde la galería o cámara del dispositivo.
- _shared_preferences_: Almacena datos persistentes y simples localmente en el dispositivo.
- _url_launcher_: Abre enlaces web, números de teléfono, o aplicaciones externas.
- _share_plus_: Comparte contenido desde la aplicación a otras apps o plataformas.

# Instalacion
1. **Clonar el repositorio:**
  ```bash
    git clone example@example.com/path/to/my-project.git 
  ```

2. **Instalar dependencias:**
  ```bash
    flutter pub get
  ```

3. **Ejecución**  
Para ejecutar la aplicación en un emulador o dispositivo físico:
  ```bash
    flutter run
  ```