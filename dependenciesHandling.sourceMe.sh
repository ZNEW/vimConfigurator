#!/bin/bash

source ./toolInstallation.sourceMe.sh

#----------------------------------------------------------------------------------------------------------------------
function logWithSourceInfo
{
  log "$1" "$2" "$BASH_SOURCE"

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function exitOnErrorWithSourceInfo
{
  exitOnError "$1" "$2" "$BASH_SOURCE"
}

#----------------------------------------------------------------------------------------------------------------------
function tryToInstall
{
  expectedToolName=$1

  logWithSourceInfo "Checking ${expectedToolName}" $LINENO

  for elt in "${toolsInstallationCommandByName[@]}";
  do

    IFS=', ' read -r -a toolInstallationCommandsArray <<< "$elt"

    currentToolName=$toolInstallationCommandsArray

    if [ $currentToolName == $expectedToolName ]
    then
      for index in "${!toolInstallationCommandsArray[@]}"
      do
        if [ "$index" -ne "0" ]
        then
          ${toolInstallationCommandsArray[index]}
        fi

      done
    fi
  done

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function tryToInstallToolIfNotAvailable
{
  if command -v $1 &>/dev/null; then
    logWithSourceInfo "\t$(tput setaf 2)$1 was found !$(tput sgr 0)" $LINENO
  else
    logWithSourceInfo "\t$(tput setaf 1)$1 was not found !$(tput sgr 0)" $LINENO
    tryToInstall $1
  fi

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function checkPluginDependenciesOf
{
  checkedPluginName=$1

  logWithSourceInfo "Checking Dependencies of ${checkedPluginName}" $LINENO

  for elt in "${pluginsDependenciesByName[@]}"; do

    IFS=', ' read -r -a dependenciesEltsArray <<< "$elt"

    dependenciesPluginName=$dependenciesEltsArray

    if [ $dependenciesPluginName == $checkedPluginName ]
    then
      for index in "${!dependenciesEltsArray[@]}"
      do
        if [ "$index" -ne "0" ]
        then
          tryToInstallToolIfNotAvailable ${dependenciesEltsArray[index]}
        fi

      done
    fi
  done

  return 0
}


