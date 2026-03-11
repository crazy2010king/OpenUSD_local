#!/bin/bash

# Unified runner script for all OpenUSD examples

USD_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)
BUILD_DIR="$USD_ROOT/local/build"
EXAMPLES_DIR="$USD_ROOT/local/examples"

# Set up environment
export PATH="$USD_ROOT/bin:$PATH"
export LD_LIBRARY_PATH="$USD_ROOT/lib:$LD_LIBRARY_PATH"
export PXR_PLUGINPATH_NAME="$BUILD_DIR:$PXR_PLUGINPATH_NAME"

# Example lists
exec_examples=("computingValues" "definingComputations")
core_examples=(
  "usdResolverExample"
  "usdRecursivePayloadsExample"
  "usdDancingCubesExample"
  "usdObj"
  "usdGeomExamples"
  "usdMakeFileVariantModelAsset"
  "usdSchemaExamples"
  "usdSemanticsExamples"
  "usdviewPlugins"
)
imaging_examples=("hdTiny" "hdParticleField")
physics_examples=(
  "usdPhysicsBoxOnBox"
  "usdPhysicsBoxOnQuad"
  "usdPhysicsDistanceJoint"
  "usdPhysicsGroupFiltering"
  "usdPhysicsJoints"
  "usdPhysicsNestedArticulation"
  "usdPhysicsPairFiltering"
  "usdPhysicsSpheresWithMaterial"
)

show_menu() {
  echo "=== OpenUSD Example Runner ==="
  echo "1. Run all examples"
  echo "2. Run exec framework examples"
  echo "3. Run core USD examples"
  echo "4. Run imaging/rendering examples"
  echo "5. Run physics examples"
  echo "6. Run specific example"
  echo "7. Exit"
  echo -n "Please select an option: "
  read choice
}

run_exec_example() {
  local example=$1
  echo -e "\n=== Running exec example: $example ==="
  "$BUILD_DIR/exec/$example/$example"
  echo -e "\n--- Completed $example ---"
}

run_core_example() {
  local example=$1
  echo -e "\n=== Running core example: $example ==="
  if [ -x "$BUILD_DIR/core/$example/$example" ]; then
    "$BUILD_DIR/core/$example/$example"
  elif [ -x "$BUILD_DIR/core/$example/testenv/test_$example" ]; then
    "$BUILD_DIR/core/$example/testenv/test_$example"
  else
    echo "No executable found for $example, checking for demo scripts..."
    if [ -f "$EXAMPLES_DIR/core/$example/demo.py" ]; then
      python3 "$EXAMPLES_DIR/core/$example/demo.py"
    else
      echo "Could not find way to run $example"
    fi
  fi
  echo -e "\n--- Completed $example ---"
}

run_imaging_example() {
  local example=$1
  echo -e "\n=== Running imaging example: $example ==="
  if [ "$example" = "hdTiny" ]; then
    echo "Running hdTiny renderer test..."
    "$BUILD_DIR/imaging/hdTiny/testenv/testHdTiny"
  else
    "$BUILD_DIR/imaging/$example/$example"
  fi
  echo -e "\n--- Completed $example ---"
}

run_physics_example() {
  local example=$1
  echo -e "\n=== Running physics example: $example ==="
  usdview "$EXAMPLES_DIR/physics/$example.usda"
  echo -e "\n--- Completed $example ---"
}

run_all() {
  echo "Running all examples..."
  for ex in "${exec_examples[@]}"; do run_exec_example "$ex"; done
  for ex in "${core_examples[@]}"; do run_core_example "$ex"; done
  for ex in "${imaging_examples[@]}"; do run_imaging_example "$ex"; done
  for ex in "${physics_examples[@]}"; do run_physics_example "$ex"; done
  echo -e "\n=== All examples completed! ==="
}

run_category() {
  local category=$1
  shift
  local examples=("$@")

  echo -e "\n=== Running $category examples ==="
  for i in "${!examples[@]}"; do
    echo "$((i+1)). ${examples[$i]}"
  done
  echo "a. Run all in category"
  echo -n "Select example to run: "
  read sel

  if [ "$sel" = "a" ]; then
    for ex in "${examples[@]}"; do "run_${category}_example" "$ex"; done
  else
    local idx=$((sel-1))
    if [ $idx -ge 0 ] && [ $idx -lt ${#examples[@]} ]; then
      "run_${category}_example" "${examples[$idx]}"
    else
      echo "Invalid selection"
    fi
  fi
}

run_specific() {
  echo "Available examples:"
  echo "Exec examples: ${exec_examples[*]}"
  echo "Core examples: ${core_examples[*]}"
  echo "Imaging examples: ${imaging_examples[*]}"
  echo "Physics examples: ${physics_examples[*]}"
  echo -n "Enter example name to run: "
  read ex

  if [[ " ${exec_examples[@]} " =~ " $ex " ]]; then
    run_exec_example "$ex"
  elif [[ " ${core_examples[@]} " =~ " $ex " ]]; then
    run_core_example "$ex"
  elif [[ " ${imaging_examples[@]} " =~ " $ex " ]]; then
    run_imaging_example "$ex"
  elif [[ " ${physics_examples[@]} " =~ " $ex " ]]; then
    run_physics_example "$ex"
  else
    echo "Example not found: $ex"
  fi
}

# Main loop
while true; do
  show_menu
  case $choice in
    1) run_all ;;
    2) run_category "exec" "${exec_examples[@]}" ;;
    3) run_category "core" "${core_examples[@]}" ;;
    4) run_category "imaging" "${imaging_examples[@]}" ;;
    5) run_category "physics" "${physics_examples[@]}" ;;
    6) run_specific ;;
    7) echo "Exiting..."; exit 0 ;;
    *) echo "Invalid option, please try again" ;;
  esac
  echo -n "Press enter to continue..."
  read
done
