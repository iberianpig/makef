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
    if [ -f ./Makefile ] && [ "$MAKEF_PATH" != ./Makefile ]; then
      path=$(mktemp)
      cat ./Makefile "$MAKEF_PATH" > "$path"
    else
      path="$MAKEF_PATH"
    fi
  echo $path
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
        exit 1
        ;;
    esac
  else
    _create_makefile
  fi
}

_create_makefile() {
    cat << 'EOF' > "$MAKEF_PATH"
.PHONY: all

all: help

help: ## show this messages
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

NO_PHONY = /^:/
PHONY := $(shell cat $(MAKEFILE_LIST) | awk -F':' '/^[a-z0-9_.-]+:/ && !$(NO_PHONY) {print $$1}')
.PHONY: $(PHONY)

show_phony: ## show phony
	@echo $(PHONY)
EOF
}
