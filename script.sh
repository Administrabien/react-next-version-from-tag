#!/bin/bash
set -e

# 1. Obtener la versión del package.json (ej: 1.0.0)
PACKAGE_VERSION=$(node -p "require('./package.json').version")
echo "Versión en package.json: $PACKAGE_VERSION"

# 2. Obtener el último tag que empieza con 'v'
git fetch --tags --force
# Buscamos el tag más reciente. Si no existe, usamos v0.0.0.0 como base
LAST_TAG=$(git tag -l "v*" --sort=-creatordate | head -n 1)

if [ -z "$LAST_TAG" ]; then
    LAST_TAG="v0.0.0.0"
fi
echo "Último tag detectado: $LAST_TAG"

# 3. Quitar la 'v' inicial
TAG_CLEAN=${LAST_TAG#v} 0.0.1

# 4. Dividir el tag en los 3 números de la izquierda (BASE) y el de la derecha (LAST)
# Expresión regular para separar: los primeros 3 grupos y el último
# Si el tag es v1.0.0.5 -> BASE_TAG=1.0.0, LAST=5
BASE_TAG=$(echo $TAG_CLEAN | cut -d. -f1-3)
LAST=$(echo $TAG_CLEAN | cut -d. -f4)

echo "BASE_TAG: $BASE_TAG"
echo "LAST: $LAST"

# Si el tag no tiene 4 partes (ej: v1.0.0), LAST estará vacío
LAST=${LAST:-0}

# 5, 6 y 7. Comparación de versiones
if [ "$PACKAGE_VERSION" == "$BASE_TAG" ]; then
    echo "Las versiones coinciden. Incrementando número de release."
    LAST=$((LAST + 1))
else
    echo "Nueva versión detectada en package.json. Reiniciando release a 0."
    LAST=0
fi

# 8. Concatenar para formar la versión final (x.x.x.x)
NEXT_VERSION="$PACKAGE_VERSION.$LAST"
echo "NEXT_VERSION calculada: $NEXT_VERSION"

# 9. Retornar los valores a GitHub Actions
echo "NEXT_VERSION=$NEXT_VERSION" >> "$GITHUB_OUTPUT"
echo "TAG_NAME=v$NEXT_VERSION" >> "$GITHUB_OUTPUT"