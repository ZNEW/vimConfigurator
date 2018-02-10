#!/bin/bash

ctagsUrl=http://www.vim.org/scripts/download_script.php?src_id=10387
pythonUrl=https://www.python.org/ftp/python/2.7.14/python-2.7.14.msi
gitUrl=undefined

#----------------------------------------------------------------------------------------------------------------------
expectedPlugins=(
  'mileszs/ack.vim'
  'vim-scripts/ctags.vim'
  'ctrlpvim/ctrlp.vim'
  'vim-scripts/fontsize'
  'fholgado/minibufexpl.vim'
  'scrooloose/nerdtree'
  'vim-syntastic/syntastic'
  'vim-scripts/taglist.vim'
  'SirVer/ultisnips'
  'vim-airline/vim-airline'
  'junegunn/vim-easy-align'
  'tpope/vim-fugitive'
  'airblade/vim-gitgutter'
  'xolox/vim-misc'
  'xolox/vim-notes'
  'honza/vim-snippets'
  'tpope/vim-surround'
  'vim-scripts/visual_studio.vim'
  'michalbachowski/vim-wombat256mod'
  'ryanoasis/vim-devicons'
  'ryanoasis/powerline-extra-symbols'
)

#----------------------------------------------------------------------------------------------------------------------
sourcedConfigurationFiles=(
  'Abbreviations.vim'
  'AutoIndent.vim'
  'Autocmd.vim'
  'Backup.vim'
  'EditorConfig.vim'
  'KeyMapping.vim'
  'Keyboard.vim'
  'Mouse.vim'
  'Refactoring.vim'
  'RestoreLastCursorPos.vim'
  'ThemeAndSyntaxHighlighting.vim'
  'WindowsTransparencyOnFocus.vim'
  'mswin.vim'
  'myFontSize.vim'
  'silver-searcher.vim'
)

#----------------------------------------------------------------------------------------------------------------------
sourcedPluginsConfigurationFilesByPluginNames=(
  'vim-scripts/ctags.vim      CtagsConfig.vim'
  'ctrlpvim/ctrlp.vim         CtrlpConfig.vim'
  'fholgado/minibufexpl.vim   MiniBufExplorer.Config.vim'
  'scrooloose/nerdtree        NERDTreeConfig.vim'
  'vim-scripts/taglist.vim    TagListConfig.vim'
  'SirVer/ultisnips           UltiSnips.vim'
  'xolox/vim-notes            vim-notes.vim'
)

#----------------------------------------------------------------------------------------------------------------------
pluginsDependenciesByName=(
  'vim-scripts/ctags.vim    ctags'
  'SirVer/ultisnips         python'
  'airblade/vim-gitgutter   git'
)

#----------------------------------------------------------------------------------------------------------------------
toolsInstallationCommandByName=(
  'ctags  instalCtags'
  'git    installGit'
  'python installPython'
)

