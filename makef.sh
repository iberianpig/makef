makef() {
  make -f "$(makefpath)" "$@"
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
  local path
  if [ "$MAKEF_PATH" ]; then
    if [ -f ./Makefile ] && [ "$MAKEF_PATH" != ./Makefile ]; then
      path=$(mktemp)
      cat ./Makefile "$MAKEF_PATH" > "$path"
    else
      path="$MAKEF_PATH"
    fi
  elif [ -f ./Makefile ]; then
    path="./Makefile"
  fi
  echo $path
}

makefedit()
{
  local path
  if [ "$MAKEF_PATH" ]; then
    path="$MAKEF_PATH"
  else
    path="./Makefile"
  fi
  $EDITOR $path
}
