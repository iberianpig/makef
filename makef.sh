makef() {
  if [ ! "$(makefpath)" ]; then
    make "$@"
  else
    make -f "$(makefpath)" "$@"
  fi
}

_makef()
{
  if [ ! "$(makefpath)" ]; then
    return
  fi
  COMPREPLY=( $(compgen -W "$(grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' "$(makefpath)" | sed 's/[^a-zA-Z0-9_.-]*$//')" "$2") )
}
complete -F _makef makef

makefpath()
{
  if [ "$MAKEF_PATH" ]; then
    local path
    if [ "$(makefile_original)" ] && [ "$MAKEF_PATH" != "$(makefile_original)" ]; then
      path=$(mktemp) # path is temporary file for merging
      cat "$(makefile_original)" "$MAKEF_PATH" > "$path"
    else
      path="$MAKEF_PATH"
    fi
    echo $path
  fi
}

# $MAKEFILE: source Makefile. if not set, use ./Makefile
# $MAKEF_PATH: Makefile path for override $MAKEFILE
makefile_original()
{
  if [ "$MAKEFILE" ]; then
    echo "$MAKEFILE"
  elif [ -f ./Makefile ]; then
    echo ./Makefile
  fi
}

makefedit()
{
  if [ "$MAKEF_PATH" ]; then
    $EDITOR "$MAKEF_PATH"
  else
    echo '"$MAKEF_PATH" is not set' >&2
    return 1
  fi
}

makefinit() {
  if [ -f "$MAKEF_PATH" ]; then
    read -p "$MAKEF_PATH already exists. Overwrite? (y/N) " answer
    case "$answer" in
      y|Y)
        _create_makefile
        ;;
      *)
        echo "Aborted."
        return 1
        ;;
    esac
  else
    _create_makefile
  fi
}

_create_makefile() {
  if [ "$MAKEF_PATH" ]; then
    cat << 'EOF' > "$MAKEF_PATH"

all: help

help: ## show this messages
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
MAKEF := $(MAKE) -f $(MAKEFILE_DIR)/Makefile

MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
MAKEF := $(MAKE) -f $(MAKEFILE_DIR)/Makefile

NO_PHONY = /^:/
PHONY := $(shell cat $(MAKEFILE_LIST) | awk -F':' '/^[a-z0-9_.-]+:/ && !$(NO_PHONY) {print $$1}')
.PHONY: $(PHONY)

show_phony: ## show phony
	@echo $(PHONY)
EOF
  else
    echo '"$MAKEF_PATH" is not set' >&2
    return 1
  fi
}
