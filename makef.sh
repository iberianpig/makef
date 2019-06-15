function makef() {
  make -f "$(makef_path)" "$@"
}

_makef()
{
  if [ ! "$(makef_path)" ]; then
    return
  fi
  COMPREPLY=( $(compgen -W "$(grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' "$(makef_path)" | sed 's/[^a-zA-Z0-9_.-]*$//')" "$2") )
}
complete -F _makef makef

makef_path()
{
  local path
  if [ "$MAKEF_PATH" ]; then
    if [ -f ./Makefile ] && [ "$MAKEF_PATH" != ./Makefile ]; then
      path=$(tempfile)
      cat ./Makefile "$MAKEF_PATH" > "$path"
    else
      path="$MAKEF_PATH"
    fi
  elif [ -f ./Makefile ]; then
    path="./Makefile"
  fi
  echo $path
}
