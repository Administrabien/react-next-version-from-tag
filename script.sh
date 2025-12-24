#!/bin/bash
set -e

# 1. Extraer versión del package.json
PACKAGE_VERSION=$(node -p "require('./package.json').version")
# Separar package version en Major, Minor, Release
IFS='.' read -r P_MAJOR P_MINOR P_RELEASE <<< "$PACKAGE_VERSION"

# 2. Extraer el último tag que empiece con "v"
git fetch --tags --force
LAST_TAG=$(git tag -l "v*" --sort=-creatordate | head -n 1)

if [ -z "$LAST_TAG" ]; then
    # Si no hay tags, usamos la versión del package.json con release en 0
    LAST_TAG="v0.0.0"
fi

# Limpiar la 'v' del tag
TAG_VERSION=${LAST_TAG#v}
IFS='.' read -r T_MAJOR T_MINOR T_RELEASE <<< "$TAG_VERSION"

# 3 y 4. Lógica de comparación
if [ "$P_MAJOR" -eq "$T_MAJOR" ] && [ "$P_MINOR" -eq "$T_MINOR" ]; then
    # Son iguales: Usamos base del tag e incrementamos release del tag
    NEXT_RELEASE=$((T_RELEASE + 1))
    NEXT_VERSION="$T_MAJOR.$T_MINOR.$NEXT_RELEASE"
else
    # Son distintos: Usamos base del package e incrementamos su propio release
    NEXT_RELEASE=$((P_RELEASE + 1))
    NEXT_VERSION="$P_MAJOR.$P_MINOR.$NEXT_RELEASE"
fi

# 5. Crear el tag en el repo (solo localmente en el runner, el push se hace después)
TAG_NAME="v$NEXT_VERSION"
echo "Creando nuevo tag: $TAG_NAME"
git tag $TAG_NAME

# 6. Retornar el valor a GitHub Actions
echo "NEXT_VERSION=$NEXT_VERSION" >> "$GITHUB_OUTPUT"
echo "TAG_NAME=$TAG_NAME" >> "$GITHUB_OUTPUT"