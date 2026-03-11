#!/usr/bin/env python3
"""
Test script for OpenUSD examples
Automatically compiles, runs, and validates all examples
"""

import os
import sys
import subprocess
import json
from pathlib import Path

USD_ROOT = Path(__file__).parent.parent.parent.resolve()
BUILD_DIR = USD_ROOT / "local" / "build"
EXAMPLES_DIR = USD_ROOT / "local" / "examples"

# Set up environment
os.environ["PATH"] = f"{USD_ROOT / 'bin'}:{os.environ.get('PATH', '')}"
os.environ["LD_LIBRARY_PATH"] = f"{USD_ROOT / 'lib'}:{os.environ.get('LD_LIBRARY_PATH', '')}"
os.environ["PXR_PLUGINPATH_NAME"] = f"{BUILD_DIR}:{os.environ.get('PXR_PLUGINPATH_NAME', '')}"

TEST_RESULTS = []

def run_command(cmd, cwd=None, timeout=300):
    """Run a command and return success status and output"""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=timeout
        )
        return (result.returncode == 0, result.stdout, result.stderr)
    except subprocess.TimeoutExpired:
        return (False, "", "Command timed out after {} seconds".format(timeout))
    except Exception as e:
        return (False, "", str(e))

def test_exec_examples():
    """Test exec framework examples"""
    examples = ["computingValues", "definingComputations"]

    for example in examples:
        print(f"\n=== Testing exec example: {example} ===")
        exe_path = BUILD_DIR / "exec" / example / example

        if not exe_path.exists():
            TEST_RESULTS.append({
                "category": "exec",
                "name": example,
                "status": "SKIPPED",
                "reason": "Executable not found"
            })
            print(f"❌ {example}: SKIPPED (executable not found)")
            continue

        success, stdout, stderr = run_command(str(exe_path))

        if success:
            TEST_RESULTS.append({
                "category": "exec",
                "name": example,
                "status": "PASSED",
                "output": stdout[:500]
            })
            print(f"✅ {example}: PASSED")
        else:
            TEST_RESULTS.append({
                "category": "exec",
                "name": example,
                "status": "FAILED",
                "error": stderr[:1000]
            })
            print(f"❌ {example}: FAILED")
            print(f"Error: {stderr[:500]}")

def test_core_examples():
    """Test core USD examples"""
    examples = [
        "usdResolverExample",
        "usdRecursivePayloadsExample",
        "usdDancingCubesExample",
        "usdObj",
        "usdGeomExamples",
        "usdMakeFileVariantModelAsset",
        "usdSchemaExamples",
        "usdSemanticsExamples",
        "usdviewPlugins"
    ]

    for example in examples:
        print(f"\n=== Testing core example: {example} ===")
        exe_path1 = BUILD_DIR / "core" / example / example
        exe_path2 = BUILD_DIR / "core" / example / "testenv" / f"test_{example}"

        exe_path = None
        if exe_path1.exists():
            exe_path = exe_path1
        elif exe_path2.exists():
            exe_path = exe_path2

        if not exe_path:
            # Check for demo script
            demo_script = EXAMPLES_DIR / "core" / example / "demo.py"
            if demo_script.exists():
                success, stdout, stderr = run_command(f"python3 {demo_script}")
            else:
                TEST_RESULTS.append({
                    "category": "core",
                    "name": example,
                    "status": "SKIPPED",
                    "reason": "No executable or demo script found"
                })
                print(f"❌ {example}: SKIPPED (no runnable target found)")
                continue
        else:
            success, stdout, stderr = run_command(str(exe_path))

        if success:
            TEST_RESULTS.append({
                "category": "core",
                "name": example,
                "status": "PASSED",
                "output": stdout[:500]
            })
            print(f"✅ {example}: PASSED")
        else:
            TEST_RESULTS.append({
                "category": "core",
                "name": example,
                "status": "FAILED",
                "error": stderr[:1000]
            })
            print(f"❌ {example}: FAILED")
            print(f"Error: {stderr[:500]}")

def test_imaging_examples():
    """Test imaging/rendering examples"""
    examples = ["hdTiny", "hdParticleField"]

    for example in examples:
        print(f"\n=== Testing imaging example: {example} ===")
        if example == "hdTiny":
            exe_path = BUILD_DIR / "imaging" / example / "testenv" / "testHdTiny"
        else:
            exe_path = BUILD_DIR / "imaging" / example / example

        if not exe_path.exists():
            TEST_RESULTS.append({
                "category": "imaging",
                "name": example,
                "status": "SKIPPED",
                "reason": "Executable not found"
            })
            print(f"❌ {example}: SKIPPED (executable not found)")
            continue

        success, stdout, stderr = run_command(str(exe_path))

        if success:
            TEST_RESULTS.append({
                "category": "imaging",
                "name": example,
                "status": "PASSED",
                "output": stdout[:500]
            })
            print(f"✅ {example}: PASSED")
        else:
            TEST_RESULTS.append({
                "category": "imaging",
                "name": example,
                "status": "FAILED",
                "error": stderr[:1000]
            })
            print(f"❌ {example}: FAILED")
            print(f"Error: {stderr[:500]}")

def test_physics_examples():
    """Test physics examples (validate USD files)"""
    examples = [
        "usdPhysicsBoxOnBox",
        "usdPhysicsBoxOnQuad",
        "usdPhysicsDistanceJoint",
        "usdPhysicsGroupFiltering",
        "usdPhysicsJoints",
        "usdPhysicsNestedArticulation",
        "usdPhysicsPairFiltering",
        "usdPhysicsSpheresWithMaterial"
    ]

    for example in examples:
        print(f"\n=== Testing physics example: {example} ===")
        usd_path = EXAMPLES_DIR / "physics" / f"{example}.usda"

        if not usd_path.exists():
            TEST_RESULTS.append({
                "category": "physics",
                "name": example,
                "status": "SKIPPED",
                "reason": "USD file not found"
            })
            print(f"❌ {example}: SKIPPED (USD file not found)")
            continue

        # Validate USD file
        success, stdout, stderr = run_command(f"usdchecker {usd_path}")

        if success:
            TEST_RESULTS.append({
                "category": "physics",
                "name": example,
                "status": "PASSED",
                "output": "USD file is valid"
            })
            print(f"✅ {example}: PASSED (USD file valid)")
        else:
            TEST_RESULTS.append({
                "category": "physics",
                "name": example,
                "status": "FAILED",
                "error": stderr[:1000]
            })
            print(f"❌ {example}: FAILED")
            print(f"Error: {stderr[:500]}")

def generate_report():
    """Generate test report"""
    print("\n" + "="*80)
    print("TEST REPORT")
    print("="*80)

    total = len(TEST_RESULTS)
    passed = len([r for r in TEST_RESULTS if r["status"] == "PASSED"])
    failed = len([r for r in TEST_RESULTS if r["status"] == "FAILED"])
    skipped = len([r for r in TEST_RESULTS if r["status"] == "SKIPPED"])

    print(f"Total tests: {total}")
    print(f"Passed: {passed} ✅")
    print(f"Failed: {failed} ❌")
    print(f"Skipped: {skipped} ⚠️")
    print(f"Success rate: {passed/total*100:.1f}%")

    print("\n" + "="*80)
    print("FAILED TESTS:")
    for r in TEST_RESULTS:
        if r["status"] == "FAILED":
            print(f"  ❌ {r['category']}/{r['name']}: {r.get('error', 'Unknown error')[:200]}")

    # Save full report to JSON
    report_path = USD_ROOT / "local" / "test_report.json"
    with open(report_path, "w") as f:
        json.dump(TEST_RESULTS, f, indent=2)

    print(f"\nFull report saved to: {report_path}")

    return failed == 0

def main():
    print("OpenUSD Example Test Suite")
    print(f"USD Root: {USD_ROOT}")
    print(f"Build Directory: {BUILD_DIR}")

    # Run all tests
    test_exec_examples()
    test_core_examples()
    test_imaging_examples()
    test_physics_examples()

    # Generate report
    success = generate_report()

    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
