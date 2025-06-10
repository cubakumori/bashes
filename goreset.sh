#!/bin/bash

# ===========================================
# 🧾 goreset.sh — Limpia y recompila un proyecto Go
#
# 🛠 ¿Qué hace este script?
#   - Limpia la caché de compilación y pruebas
#   - Detecta automáticamente el nombre del ejecutable
#   - Borra binarios anteriores
#   - Actualiza dependencias del proyecto
#   - Recompila completamente desde cero
#
# 🚀 Cómo usarlo:
#   1. Guarda este archivo como 'goreset.sh' en la raíz del proyecto
#   2. Dale permisos de ejecución: chmod +x goreset.sh
#   3. Ejecuta: ./goreset.sh
# ===========================================

# Comprobar si el paquete actual es 'main'
if ! grep -q '^package main' ./*.go 2>/dev/null; then
  echo "❌ Este directorio no contiene un paquete 'main'."
  echo "ℹ️  No se puede compilar un ejecutable si no es un paquete 'main'."
  exit 1
fi

# Detectar nombre del ejecutable
if [ -f "go.mod" ]; then
  MODULE_NAME=$(grep '^module ' go.mod | awk '{print $2}' | sed 's|.*/||')
else
  MODULE_NAME=$(basename "$PWD")
fi

echo "🔍 Ejecutable detectado: $MODULE_NAME"

# Paso 1: Limpiar caché
echo "🧹 Limpiando caché de Go..."
go clean -cache -testcache

# Paso 2: Borrar binario previo si existe
echo "🗑️  Eliminando binario previo..."
rm -f "$MODULE_NAME" "$MODULE_NAME.exe"

# Paso 3: Actualizar dependencias
echo "🔄 Ejecutando go mod tidy & download..."
go mod tidy
go mod download

# Paso 4: Compilar desde cero
echo "🔨 Compilando proyecto..."
go build -a -o "$MODULE_NAME" .

# Confirmación final
if [ -f "$MODULE_NAME" ]; then
  echo "✅ Compilación limpia completada. Binario generado: ./$MODULE_NAME"
else
  echo "⚠️  Algo falló: no se generó el binario."
fi