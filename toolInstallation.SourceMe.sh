#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------
function logWithSourceInfo
{
  log "$1" "$2" "$BASH_SOURCE"
}

#----------------------------------------------------------------------------------------------------------------------
function exitOnErrorWithSourceInfo
{
  exitOnError "$1" "$2" "$BASH_SOURCE"
}

#----------------------------------------------------------------------------------------------------------------------
function installPython
{
  case "${unameOut}" in
    MINGW*)
      logWithSourceInfo "Installing Python from ${pythonUrl}" $LINENO
      curl -LSso $TMP/python.msi ${pythonUrl}
      start $TMP/python.msi ;;

    *)
      exitOnErrorWithSourceInfo "No Python Installation Available for ${unameOut}" $LINENO ;;

  esac
}


#----------------------------------------------------------------------------------------------------------------------
function installGit
{
  case "${unameOut}" in
    MINGW*)
      logWithSourceInfo "Installing Git from ${gitUrl}" $LINENO
      logWithSourceInfo "curl -LSso $TMP/??????.msi ${gitUrl}" $LINENO
      logWithSourceInfo "start $TMP/?????.msi" $LINENO ;;

    *)
      exitOnErrorWithSourceInfo "No Git Installation Available for ${unameOut}" ;;

  esac

  return 0
}


#----------------------------------------------------------------------------------------------------------------------
function instalCtags
{
  case "${unameOut}" in
    MINGW*)
      logWithSourceInfo "Installing Ctags from ${ctagsUrl}" $LINENO
      curl -LSso ${vimFolderPath}/bin/ctags.bin.exe ${ctagsUrl}

      logWithSourceInfo "Creating Ctags shortcut" $LINENO
      echo ${vimFolderPath}/bin/ctags.exe > ${vimFolderPath}/bin/ctags

      chmod u+x ${vimFolderPath}/bin/ctags.bin.exe
      chmod u+x ${vimFolderPath}/bin/ctags

      mv ${vimFolderPath}/bin/ctags.bin.exe ${vimFolderPath}/bin/ctags.exe ;;

    *)
      exitOnErrorWithSourceInfo "No Ctags Installation Available for ${unameOut}" $LINENO;;

  esac

  return 0
}
