# bashes / bash collector

Aquí recopilo los bashes que me han sido de utilidad en algún momento.

## goreset.sh
Limpia y recompila un **proyecto Go**
- Limpia la caché de compilación y pruebas
- Detecta automáticamente el nombre del ejecutable
- Borra binarios anteriores
- Actualiza dependencias del proyecto
- Recompila completamente desde cero



## wailsreset.sh
Limpieza total de un **proyecto Wails**

**Uso:**


    ./wailsreset.sh          → modo interactivo

    ./wailsreset.sh --full   → limpieza completa sin preguntar

    

**Limpia:**
- Caché de Go
- Binario anterior
- Archivos temporales de Wails
- (Opcional o automática) node_modules, dist del frontend
- (Opcional o automática) reinstalación de dependencias frontend
