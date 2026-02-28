#!/bin/bash
set -e

# Color codes for output
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Terraform directories
declare -A TF_DIRS=(
  [bootstrap]="./infra/bootstrap"
  [identity]="./infra/identity"
  [dev]="./infra/environments/dev"
  [prod]="./infra/environments/prod"
)

# Function to display outputs for a given module
show_module_output() {
  local module=$1
  local dir=${TF_DIRS[$module]}
  local output

  if [ ! -d "$dir" ]; then
    echo "⚠  Directory not found: $dir"
    return 1
  fi

  echo -e "${BOLD}${CYAN}=== $module ===${NC}"

  if output=$(terraform -chdir="$dir" output -json 2>&1); then
    echo "$output"
    echo
    return 0
  fi

  if echo "$output" | grep -qiE "backend initialization required|terraform init|initialized|initialization"; then
    echo "→ Initializing Terraform in $module..."
    if ! terraform -chdir="$dir" init -input=false >/dev/null 2>&1; then
      echo "⚠  Failed to initialize Terraform for $module"
      echo "   Run: terraform -chdir=$dir init"
      echo
      return 1
    fi

    if output=$(terraform -chdir="$dir" output -json 2>&1); then
      echo "$output"
      echo
      return 0
    fi
  fi

  if echo "$output" | grep -qi "No outputs found"; then
    echo "⚠  No outputs found for $module. Resources may not be applied yet."
    echo "   Run: terraform -chdir=$dir apply"
    echo
    return 1
  fi

  if echo "$output" | grep -qiE "No state file was found|state snapshot was created"; then
    echo "⚠  No readable Terraform state found for $module."
    echo "   Run: terraform -chdir=$dir init && terraform -chdir=$dir apply"
    echo
    return 1
  fi

  echo "⚠  Unable to read outputs for $module"
  echo "   Run: terraform -chdir=$dir output -json"
  echo
  return 1
}

# Function to show interactive menu
show_menu() {
  echo
  echo -e "${BOLD}Terraform Outputs Menu${NC}"
  echo "Select modules to display:"
  echo
  echo "1) bootstrap"
  echo "2) identity"
  echo "3) dev"
  echo "4) prod"
  echo "5) all"
  echo "0) exit"
  echo
  read -p "Enter your choice(s) (comma-separated, e.g., 1,2,3): " choice

  case $choice in
    0)
      exit 0
      ;;
    5)
      SELECTED_MODULES=(bootstrap identity dev prod)
      ;;
    *)
      SELECTED_MODULES=()
      IFS=',' read -ra CHOICES <<< "$choice"
      for c in "${CHOICES[@]}"; do
        c=${c//[[:space:]]/}
        case $c in
          1) SELECTED_MODULES+=(bootstrap) ;;
          2) SELECTED_MODULES+=(identity) ;;
          3) SELECTED_MODULES+=(dev) ;;
          4) SELECTED_MODULES+=(prod) ;;
          *)
            echo "Invalid choice: $c"
            exit 1
            ;;
        esac
      done
      ;;
  esac
}

# Check Terraform CLI
if ! command -v terraform >/dev/null 2>&1; then
  echo "Error: Terraform CLI not found. Please install Terraform."
  exit 1
fi

# Determine which modules to display
if [ $# -eq 0 ]; then
  # No arguments, show interactive menu
  show_menu
else
  # Arguments provided, use them as module names
  SELECTED_MODULES=()
  for arg in "$@"; do
    if [[ " ${!TF_DIRS[@]} " =~ " $arg " ]]; then
      SELECTED_MODULES+=("$arg")
    else
      echo "Error: Unknown module '$arg'. Valid options: bootstrap, identity, dev, prod"
      exit 1
    fi
  done
fi

# Display outputs for selected modules
echo
echo -e "${BOLD}Terraform Outputs${NC}"
echo

if [ ${#SELECTED_MODULES[@]} -eq 0 ]; then
  echo "No modules selected."
  exit 0
fi

for module in "${SELECTED_MODULES[@]}"; do
  show_module_output "$module" || true
done

echo -e "${GREEN}✓ Done${NC}"
