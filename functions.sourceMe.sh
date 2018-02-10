#!/bin/bash

source ./dependenciesHandling.sourceMe.sh

#----------------------------------------------------------------------------------------------------------------------
function logWithSourceInfoWithSourceInfo
{
  log "$1" "$2" "$BASH_SOURCE"
}

#----------------------------------------------------------------------------------------------------------------------
function exitOnErrorWithSourceInfo
{
  exitOnError "$1" "$2" "$BASH_SOURCE"
}

#----------------------------------------------------------------------------------------------------------------------
timeCode=`date '+%Y.%m.%d@%H-%M-%S'`
NEWLINE=$'\n'
VIM_AUTOLOAD_FOLDER_NAME=autoload

#----------------------------------------------------------------------------------------------------------------------
function checkOS ()
{
  logWithSourceInfo "$(tput setaf 3)\nSYSTEM CHECK:$(tput sgr 0)" $LINENO

  unameOut="$(uname -s)"

  case "${unameOut}" in

    Darwin*)
      machine=Mac ;;

    MINGW*)
      if command -v explorer.exe &>/dev/null;
      then
        machine="MS Windows"
      else
        exitOnErrorWithSourceInfo "Unexpected OS cannot execute on ${unameOut} (not Windows)." $LINENO
      fi
      ;;

    *)
      exitOnErrorWithSourceInfo "Unexpected OS cannot execute on ${unameOut}." $LINENO ;;

  esac

  logWithSourceInfo "${machine} found !" $LINENO

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function prepareConfiguration
{
  logWithSourceInfo "$(tput setaf 3)\nCONFIGURATION INITIALIZATION:$(tput sgr 0)" $LINENO

  case "${unameOut}" in
    Darwin*)
      vimFolderPath=~/.vim
      vimConfigFileSource=${vimFolderPath}/.vimrc
      vimConfigFilePath=~/.vimrc ;;

    MINGW*)
      vimFolderPath=$HOME/vimfiles
      vimConfigFilePath=$HOME/_vimrc ;;

  esac

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function backupExistingFolder
{
  logWithSourceInfo "$(tput setaf 3)\nBACKUP OF EXISTING FOLDER:$(tput sgr 0)" $LINENO

  folderBackupPath=${vimFolderPath}.${timeCode}.bak

  logWithSourceInfo "Renaming ${vimFolderPath} to ${folderBackupPath} if found." $LINENO

  case "${unameOut}" in
    MINGW*)
    if [ -d $HOME/.vim ] ;
    then
    echo $HOME/.vim folder found
    mv -f $HOME/.vim $HOME/.vim.${timeCode}.bak
    fi ;;
  esac

  if [ -d "${vimFolderPath}" ];
  then
    logWithSourceInfo "${vimFolderPath} found." $LINENO
    mv -f ${vimFolderPath} ${folderBackupPath}
    logWithSourceInfo "renamed to ${folderBackupPath}" $LINENO
  else
    logWithSourceInfo "No config folder found !" $LINENO
  fi

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function backupExistingConfigFile
{
  logWithSourceInfo "$(tput setaf 3)\nBACKUP OF EXISTING FILES:$(tput sgr 0)" $LINENO

  configFileBackupPath=${vimConfigFilePath}.${timeCode}.bak

  logWithSourceInfo "Renaming ${vimConfigFilePath} to ${configFileBackupPath} if found." $LINENO

  case "${unameOut}" in
    MINGW*)
    echo $HOME/.vimrc ?
    if [ -L $HOME/.vimrc ] ; then
    echo $HOME/.vimrc symbolic link found
    rm -rf $HOME/.vimrc
      fi

    if [ -f $HOME/.vimrc ] ; then
    echo $HOME/.vimrc file found
    mv -f $HOME/.vimrc ~/.vimrc.${timeCode}.bak
    fi ;;
  esac

  if [ -f "${vimConfigFilePath}" ] || [ -L "${vimConfigFilePath}" ] ;
  then
    logWithSourceInfo "${vimConfigFilePath} found." $LINENO
    mv -f ${vimConfigFilePath} ${configFileBackupPath}
    logWithSourceInfo "renamed to ${configFileBackupPath}" $LINENO

  else
    logWithSourceInfo "No config file found !" $LINENO
  fi

  return 0

}

#----------------------------------------------------------------------------------------------------------------------
function createVimFolders
{
  logWithSourceInfo "$(tput setaf 3)\nFILE SYSTEM PREPARATION:$(tput sgr 0)" $LINENO

  logWithSourceInfo "Creating vim(files), autoload & plugins system folders" $LINENO

  mkdir -p ${vimFolderPath}
  mkdir -p ${vimFolderPath}/bin
  #mkdir -p ${vimFolderPath}/${VIM_AUTOLOAD_FOLDER_NAME}
  #mkdir -p ${vimFolderPath}/colors

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function addToVimConfig
{
  echo $1 >> ${vimConfigFilePath}
  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function manageMinGW64
{
  case "${unameOut}" in
    MINGW*)
      addToVimConfig "\" Manage Vim in MINGW64"
      addToVimConfig "if system('uname -a') =~ \"MINGW64\""
      addToVimConfig "  set rtp+=\$HOME/vimfiles"
      addToVimConfig "endif"
      addToVimConfig ""
      ;;
  esac

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function addVimBinFolderToPath
{
  logWithSourceInfo "$(tput setaf 3)\nVIN BIN FOLDER CREATION:$(tput sgr 0)" $LINENO

  case "${unameOut}" in
    MINGW*)
      logWithSourceInfo "Adding Vim Bin Folder to Vim Path (for windows)" $LINENO
      addToVimConfig "\" Path setup"
      addToVimConfig "let \$PATH .= ';' . expand('\$HOME') .'\vimfiles\bin'"
      addToVimConfig "let \$PATH .= ';' . expand('\$HOME') .'\AppData\Local\Programs\Git\bin'"
      ;;
  esac

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function prepareConfigFiles
{
  logWithSourceInfo "$(tput setaf 3)\nCONFIG FILE CREATION:$(tput sgr 0)" $LINENO

  case "${unameOut}" in
    Darwin*)
      touch ${vimConfigFileSource}
      echo "" >> ${vimConfigFileSource}
      ln -s ${vimConfigFileSource} ${vimConfigFilePath} ;;

    MINGW*)
      echo "" >> ${vimConfigFilePath}

  esac

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function prepareGitRepository
{
  logWithSourceInfo "$(tput setaf 3)\nGIT REPO CREATION:$(tput sgr 0)" $LINENO

  logWithSourceInfo "Initializing vimfiles git repo" $LINENO

  cd ${vimFolderPath}
  git init
  git config --global core.autocrlf false

  git remote add origin http://github.com/ZNEW/.vim.git
  git fetch

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function installPlugVimPluginsSystem
{
  vimAutoloadFolderPath=${vimFolderPath}/autoload/

  curl -fLo ${vimAutoloadFolderPath}/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function prepareVimPlugConfiguration
{
  addToVimConfig "\" Plugins will be downloaded under the specified directory."

  case "${unameOut}" in
    Darwin*)
      addToVimConfig "call plug#begin('~/.vim/plugged')" ;;

    MINGW*)
      addToVimConfig "call plug#begin('~/vimfiles/plugged')" ;;

  esac

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function addExpectedPluginByNameAndStoreItsConfigurationFileName
{
  expectedPluginName=$1

  logWithSourceInfo "Adding ${expectedPluginName}" $LINENO

  addToVimConfig "Plug '${expectedPluginName}'"

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
sourcedPluginsConfigurationFiles=()
pluginsDependencies=()

function storePluginConfigurationFileIfFound()
{
  expectedPluginName=$1

  for elt in "${sourcedPluginsConfigurationFilesByPluginNames[@]}";
  do

    IFS=', ' read -r -a sourcedPluginsConfigurationFilesByPluginNamesArray <<< "$elt"

    currentPluginName=$sourcedPluginsConfigurationFilesByPluginNamesArray

    if [ $currentPluginName == $expectedPluginName ]
    then
      sourcedPluginsConfigurationFiles+=(${sourcedPluginsConfigurationFilesByPluginNamesArray[1]})
      logWithSourceInfo "\tConfiguration File Found: ${sourcedPluginsConfigurationFilesByPluginNamesArray[1]}" $LINENO
    fi
  done

}

#----------------------------------------------------------------------------------------------------------------------
function addExpectedPluginsAndListConfigurationFilesAndDependencies
{
  logWithSourceInfo "Adding plugins" $LINENO

  addToVimConfig "\" Declare the list of plugins."
  for elt in "${expectedPlugins[@]}"; do
    addExpectedPluginByNameAndStoreItsConfigurationFileName $elt
    storePluginConfigurationFileIfFound $elt
  done

  return 0
}


#----------------------------------------------------------------------------------------------------------------------
function finalizeVimPlugConfiguration
{
  addToVimConfig "\" List ends here. Plugins become visible to Vim after this call."
  addToVimConfig "call plug#end()"
  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function addPluginsUsingVimPlugSystemAndListConfiguration
{
  logWithSourceInfo "$(tput setaf 3)\nPLUGINS CONFIGURATION:$(tput sgr 0)" $LINENO

  installPlugVimPluginsSystem

  prepareVimPlugConfiguration

  addExpectedPluginsAndListConfigurationFilesAndDependencies

  finalizeVimPlugConfiguration

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function installPlugins
{
  logWithSourceInfo "$(tput setaf 3)\nPLUGINS INSTALLATION:$(tput sgr 0)" $LINENO

  vim -c PlugInstall +qa

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function finalizeConfiguration
{
  logWithSourceInfo "$(tput setaf 3)\nVIM BASE CONFIGURATION:$(tput sgr 0)" $LINENO

  addToVimConfig ""
  addToVimConfig "set nocompatible"
  addToVimConfig ""

  addToVimConfig "scriptencoding utf-8"
  addToVimConfig "set encoding=utf-8  \" The encoding displayed."
  addToVimConfig "set fileencoding=utf-8  \" The encoding written to file"
  addToVimConfig ""
  addToVimConfig "syntax on"
  addToVimConfig "filetype plugin indent on"

  addToVimConfig "let g:UserVimFilesFolderName =  (has('win32') || has('win64') || (system('uname -a') =~ \"MINGW64\")) ? '\$HOME/vimfiles' : '\$HOME/.vim'"
  addToVimConfig ""

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function addSourcedConfigurationFile
{
  expectedSourceConfigurationFile=$1

  logWithSourceInfo "checking $expectedSourceConfigurationFile"  $LINENO

  cd ${vimFolderPath}

  if [ -f $expectedSourceConfigurationFile ]
  then
    addToVimConfig ":exec ':source ' . g:UserVimFilesFolderName . '/$expectedSourceConfigurationFile'"

    case "${unameOut}" in
      Darwin*)
        dos2unix $expectedSourceConfigurationFile

    esac

  else
    logWithSourceInfo "$(tput setaf 6)$expectedSourceConfigurationFile not found in repository: skipping.$(tput sgr 0)"  $LINENO

  fi

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function addSourcedVimConfigurationFiles
{
  for elt in "${sourcedConfigurationFiles[@]}";
  do
    addSourcedConfigurationFile $elt
  done
  return 0
}


#----------------------------------------------------------------------------------------------------------------------
function checkOutSourcedVimConfigurationFiles
{
  logWithSourceInfo "Installing sourced configuration files"  $LINENO

  cd ${vimFolderPath}
  git checkout master
}

#----------------------------------------------------------------------------------------------------------------------
function addSourcedVimPluginsConfigurationFiles
{
  for elt in "${sourcedPluginsConfigurationFiles[@]}";
  do
    addSourcedConfigurationFile $elt
  done

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function installSourcedVimAndPluginsConfigurationFiles
{
  logWithSourceInfo "$(tput setaf 3)\nVIM AND PLUGINS CONFIGURATION:$(tput sgr 0)" $LINENO

  logWithSourceInfo "Installing sourced configuration files"  $LINENO
  checkOutSourcedVimConfigurationFiles

  addToVimConfig "${NEWLINE}"
  addToVimConfig "\" Sourced Vim Configuration Files."

  addSourcedVimConfigurationFiles

  addToVimConfig "${NEWLINE}"
  addToVimConfig "\" Sourced Vim Plugins Configuration Files."


  addSourcedVimPluginsConfigurationFiles

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function addSourcedTestScript
{
  cd ${vimFolderPath}

  touch .vimrc_experiments.vim
  git add .vimrc_experiments.vim

  addToVimConfig ""
  addToVimConfig ":exec ':source ' . g:UserVimFilesFolderName . '/.vimrc_experiments.vim'"

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function commitConfiguration
{
  logWithSourceInfo "$(tput setaf 3)\nGIT REPO COMMIT:$(tput sgr 0)" $LINENO

  git checkout -b ${timeCode}

  git commit -am "local branch ${timeCode}"

}

#----------------------------------------------------------------------------------------------------------------------
function checkPluginsDependencies
{
  logWithSourceInfo "$(tput setaf 3)\nPLUGINS DEPENDECY CHECK:$(tput sgr 0)" $LINENO
  logWithSourceInfo "Checking plugins dependencies." $LINENO

  for elt in "${expectedPlugins[@]}"; do
    checkPluginDependenciesOf $elt
  done

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function proposeFontInstallation
{
  cd ${vimFolderPath}

  logWithSourceInfo "please install font for vim-airline and vim-devicons at https://github.com/ryanoasis/nerd-fonts" $LINENO

  return 0
}

#----------------------------------------------------------------------------------------------------------------------
function installColors
{

  curl -fLo ~/.vim/colors/wombat256mod.vim --create-dirs \
    https://raw.githubusercontent.com/vim-scripts/wombat256.vim/master/colors/wombat256mod.vim

  return 0
}

