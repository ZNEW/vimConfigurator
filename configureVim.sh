#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------
# Any subsequent commands which fail will cause the shell script to exit immediately
set -e

#----------------------------------------------------------------------------------------------------------------------
source ./parameters.sourceMe.sh
source ./errorHandling.sourceMe.sh
source ./logging.sourceMe.sh
source ./functions.sourceMe.sh

#----------------------------------------------------------------------------------------------------------------------
logWithSourceInfo "$(tput setaf 2)HERE WE GO:$(tput sgr 0)" $LINENO

#----------------------------------------------------------------------------------------------------------------------
checkOS
prepareConfiguration
backupExistingFolder
backupExistingConfigFile
createVimFolders
addVimBinFolderToPath
prepareConfigFiles
manageMinGW64
prepareGitRepository
addPluginsUsingVimPlugSystemAndListConfiguration
installPlugins
finalizeConfiguration
installSourcedVimAndPluginsConfigurationFiles
addSourcedTestScript
commitConfiguration
checkPluginsDependencies
proposeFontInstallation
installColors

#----------------------------------------------------------------------------------------------------------------------
logWithSourceInfo "$(tput setaf 2)DONE !$(tput sgr 0)" $LINENO







