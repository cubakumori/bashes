#!/bin/bash

# ===========================================
# 🧾 wailsreset.sh — Limpieza total de un proyecto Wails
#
# Uso:
#   ./wailsreset.sh          → modo interactivo
#   ./wailsreset.sh --full   → limpieza completa sin preguntar
#
# Limpia:
#   - Caché de Go
#   - Binario anterior
#   - Archivos temporales de Wails
#   - (Opcional o automática) node_modules, dist del frontend
#   - (Opcional o automática) reinstalación de dependencias frontend
# ===========================================

LIMPIEZA_COMPLETA=false
if [[ "$1" == "--full" ]]; then
  LIMPIEZA_COMPLETA=true
fi

# Verificar que sea un paquete main
if ! grep -q '^package main' ./*.go 2>/dev/null; then
  echo "❌ Este directorio no contiene un paquete 'main'. No se puede compilar un ejecutable."
  exit 1
fi

# Detectar nombre del ejecutable desde go.mod
if [ -f "go.mod" ]; then
  MODULE_NAME=$(grep '^module ' go.mod | awk '{print $2}' | sed 's|.*/||')
else
  MODULE_NAME=$(basename "$PWD")
fi

echo "🔍 Ejecutable detectado: $MODULE_NAME"

echo "🧹 Limpiando caché de Go..."
go clean -cache -testcache

echo "🗑️  Eliminando binario '$MODULE_NAME'..."
rm -f "$MODULE_NAME" "$MODULE_NAME.exe"

echo "🧼 Eliminando archivos temporales de Wails..."
rm -rf build/ dist/ .wails .wailsbuild

LIMPIAR_FRONTEND=false

if $LIMPIEZA_COMPLETA; then
  LIMPIAR_FRONTEND=true
else
  read -p "¿Deseas limpiar también node_modules y dist del frontend? [s/N] " respuesta
  if [[ "$respuesta" =~ ^[sS]$ ]]; then
    LIMPIAR_FRONTEND=true
  fi
fi

if $LIMPIAR_FRONTEND; then
  if [ -d "frontend/node_modules" ]; then
    echo "🧼 Eliminando node_modules..."
    rm -rf frontend/node_modules
  fi

  if [ -d "frontend/dist" ]; then
    echo "🧼 Eliminando frontend/dist..."
    rm -rf frontend/dist
  fi

  # Restaurar dependencias frontend
  if [ -f "frontend/package.json" ]; then
    echo "📦 Instalando dependencias del frontend..."
    cd frontend
    if [ -f "pnpm-lock.yaml" ]; then
      pnpm install
    elif [ -f "yarn.lock" ]; then
      yarn install
    else
      npm install
    fi
    cd ..
  fi
else
  echo "⏭️  Saltando limpieza e instalación del frontend."
fi

echo "🔨 Ejecutando Wails en modo desarrollo..."
wails dev