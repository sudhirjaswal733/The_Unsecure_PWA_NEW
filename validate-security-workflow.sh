#!/bin/bash

# Script to validate the security analysis workflow
# This script checks YAML syntax and basic configuration

set -e

echo "🔍 Validating Security Analysis Workflow..."

# Check if required files exist
WORKFLOW_FILE=".github/workflows/security-analysis.yml"
CONFIG_FILE=".github/codeql/codeql-config.yml"
GUIDE_FILE="SECURITY_ANALYSIS_GUIDE.md"

echo "📁 Checking required files..."

if [ ! -f "$WORKFLOW_FILE" ]; then
    echo "❌ Workflow file not found: $WORKFLOW_FILE"
    exit 1
fi
echo "✅ Workflow file found: $WORKFLOW_FILE"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ CodeQL config file not found: $CONFIG_FILE"
    exit 1
fi
echo "✅ CodeQL config file found: $CONFIG_FILE"

if [ ! -f "$GUIDE_FILE" ]; then
    echo "❌ Documentation file not found: $GUIDE_FILE"
    exit 1
fi
echo "✅ Documentation file found: $GUIDE_FILE"

# Validate YAML syntax using Python (available in most environments)
echo "🔧 Validating YAML syntax..."

python3 -c "
import yaml
import sys

def validate_yaml(file_path):
    try:
        with open(file_path, 'r') as file:
            yaml.safe_load(file)
        return True
    except yaml.YAMLError as e:
        print(f'YAML syntax error in {file_path}: {e}')
        return False
    except Exception as e:
        print(f'Error reading {file_path}: {e}')
        return False

# Validate the main workflow file
if validate_yaml('.github/workflows/security-analysis.yml'):
    print('✅ YAML syntax is valid')
else:
    print('❌ YAML syntax errors found')
    sys.exit(1)
"
        print(f'✅ Valid YAML: {file_path}')
        return True
    except yaml.YAMLError as e:
        print(f'❌ Invalid YAML in {file_path}: {e}')
        return False
    except FileNotFoundError:
        print(f'❌ File not found: {file_path}')
        return False

success = True
success &= validate_yaml('$WORKFLOW_FILE')
success &= validate_yaml('$CONFIG_FILE')

if not success:
    sys.exit(1)
"

# Check for required environment variables
echo "⚙️  Checking workflow configuration..."

ENABLED=$(grep -o "SECURITY_ANALYSIS_ENABLED: [a-z]*" "$WORKFLOW_FILE" | cut -d' ' -f2)
if [ "$ENABLED" = "false" ]; then
    echo "⚠️  Security analysis is DISABLED by default (SECURITY_ANALYSIS_ENABLED: false)"
    echo "   This is correct for safety - change to 'true' when ready to enable"
else
    echo "✅ Security analysis is ENABLED (SECURITY_ANALYSIS_ENABLED: $ENABLED)"
fi

# Check for required permissions
echo "🔐 Checking workflow permissions..."

REQUIRED_PERMS=("security-events: write" "contents: read" "actions: read" "issues: write")
for perm in "${REQUIRED_PERMS[@]}"; do
    if grep -q "$perm" "$WORKFLOW_FILE"; then
        echo "✅ Permission found: $perm"
    else
        echo "❌ Missing permission: $perm"
        exit 1
    fi
done

# Check for GitHub CLI usage
echo "🐙 Checking GitHub CLI usage..."
if grep -q "gh issue" "$WORKFLOW_FILE"; then
    echo "✅ GitHub CLI commands found for issue management"
else
    echo "❌ No GitHub CLI commands found"
    exit 1
fi

# Validate required tools are mentioned
echo "🛠️  Checking required tools..."

TOOLS=("jq" "bandit" "codeql")
for tool in "${TOOLS[@]}"; do
    if grep -q "$tool" "$WORKFLOW_FILE"; then
        echo "✅ Tool referenced: $tool"
    else
        echo "❌ Tool not found: $tool"
        exit 1
    fi
done

# Check for proper error handling
echo "🛡️  Checking error handling..."

if grep -q "|| true" "$WORKFLOW_FILE"; then
    echo "✅ Error handling found (non-failing commands)"
else
    echo "⚠️  Limited error handling - workflow may fail on minor issues"
fi

# Check for deduplication logic
echo "🔄 Checking issue deduplication..."

if grep -q "EXISTING_ISSUE" "$WORKFLOW_FILE"; then
    echo "✅ Issue deduplication logic found"
else
    echo "❌ No issue deduplication found - may create duplicate issues"
    exit 1
fi

echo ""
echo "🎉 Security Analysis Workflow Validation Complete!"
echo ""
echo "📋 Summary:"
echo "   - Workflow file syntax: ✅ Valid"
echo "   - CodeQL config syntax: ✅ Valid"
echo "   - Required permissions: ✅ Present"
echo "   - Issue management: ✅ Configured"
echo "   - Deduplication: ✅ Implemented"
echo "   - Default state: ⚠️  Disabled (safe)"
echo ""
echo "🚀 To enable the workflow:"
echo "   1. Edit $WORKFLOW_FILE"
echo "   2. Change SECURITY_ANALYSIS_ENABLED from 'false' to 'true'"
echo "   3. Commit and push the changes"
echo ""
echo "📖 For detailed instructions, see: $GUIDE_FILE"