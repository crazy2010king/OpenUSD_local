#!/bin/bash
set -e

# Build script for OpenUSD examples
echo "Building OpenUSD examples..."

# Set USD root directory (assuming we're in local/scripts
USD_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)
BUILD_DIR="$USD_ROOT/local/build
EXAMPLES_DIR="$USD_ROOT/local/examples

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "Using USD_ROOT: $USD_ROOT"
echo "Build directory: $BUILD_DIR"

# Build exec examples
echo -e "\n=== Building exec examples..."
for example in computingValues definingComputations
do
  echo -e "\nBuilding $example..."
  mkdir -p "$BUILD_DIR/exec/$example"
  cd "$BUILD_DIR/exec/$example"
  cmake "$EXAMPLES_DIR/exec/$example \
    -DCMAKE_PREFIX_PATH="$USD_ROOT" \
    -DCMAKE_BUILD_TYPE=Release
  make -j$(nproc)
done

# Build core examples
echo -e "\n=== Building core examples..."
core_examples=(
  usdResolverExample
  usdRecursivePayloadsExample
  usdDancingCubesExample
  usdObj
  usdGeomExamples
  usdMakeFileVariantModelAsset
  usdSchemaExamples
  usdSemanticsExamples
  usdviewPlugins
)

for example in "${core_examples[@]
do
  if [ -d "$EXAMPLES_DIR/core/$example ]; then
    echo -e "\nBuilding $example..."
    mkdir -p "$BUILD_DIR/core/$example"
    cd "$BUILD_DIR/core/$example"
    cmake "$EXAMPLES_DIR/core/$example" \
      -DCMAKE_PREFIX_PATH="$USD_ROOT" \
      -DCMAKE_BUILD_TYPE=Release
    make -j$(nproc)
  else
    echo "Skipping $example - not found
  fi
done

# Build imaging examples
echo -e "\n=== Building imaging examples..."
imaging_examples=(hdTiny hdParticleField)
for example in "${imaging_examples[@]}"
do
  echo -e "\nBuilding $example..."
  mkdir -p "$BUILD_DIR/imaging/$example"
  cd "$BUILD_DIR/imaging/$example"
  cmake "$EXAMPLES_DIR/imaging/$example" \
    -DCMAKE_PREFIX_PATH="$USD_ROOT" \
    -DCMAKE_BUILD_TYPE=Release
  make -j$(nproc)
done

echo -e "\n=== All builds completed successfully! ==="
echo "Binaries are in $BUILD_DIR"
