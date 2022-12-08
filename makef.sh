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
