#### 言語設定
export LANG=ja_JP.UTF-8

#### プロンプト周り

# カラー表示
autoload colors
colors

# カラー表示用のエスケープ
local CYAN=$'%{\e[1;36m%}'
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'

# プロンプト表示時に式を展開する
setopt prompt_subst

# 成功か失敗かによって、区切り字の色を変える
local delim=$'%0(?||%18(?||%{\e[35m%}))$%{\e[m%}'

# PROMPT設定
# PROMPTはgitの項で変更する
PROMPT2=$''$BLUE'%_> '$DEFAULT''
SPROMPT=$''$BLUE'correct: %R -> %r [nyae]? '$DEFAULT''


# gitのbranch表示
# zsh で Git の作業コピーに変更があるかどうかをプロンプトに表示する方法 http://d.hatena.ne.jp/mollifier/20100906/p1 より引用
autoload -Uz add-zsh-hook
autoload -Uz colors
colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
  # この check-for-changes が今回の設定するところ
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
  zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当な文字列に変更する
  zstyle ':vcs_info:git:*' formats '[%b] %c%u'
  zstyle ':vcs_info:git:*' actionformats '[%b|%a] %c%u'

  # git-svnの設定(gitと同様にする)
  zstyle ':vcs_info:git-svn:*' check-for-changes true
  zstyle ':vcs_info:git-svn:*' stagedstr "+"
  zstyle ':vcs_info:git-svn:*' unstagedstr "-"
  zstyle ':vcs_info:git-svn:*' formats '[%b] %c%u'
  zstyle ':vcs_info:git-svn:*' actionformats '[%b|%a] %c%u'
fi

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
PROMPT=$''$GREEN'%~'$DEFAULT'%1(v|'$YELLOW'%1v%f'$DEFAULT'|)
'$CYAN'%n@arch %(!.#.'$delim') '$DEFAULT''

# autojump
# compinitより前にないと無効
[[ -s ~/.autojump/etc/profile.d/autojump.zsh ]] && . ~/.autojump/etc/profile.d/autojump.zsh

## Completion configuration
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit
# 改行のない出力をプロンプトで上書きしない
unsetopt promptcr

# 同じディレクトリを何度もpushdしない
setopt pushd_ignore_dups

# シェル終了前に、実行中のジョブを報告
setopt check_jobs

# {a-c}をa b cに展開
setopt brace_ccl

# globの独自拡張を有効化
setopt extended_glob

#### 以下しばらく 漢のzsh http://journal.mycom.co.jp/column/zsh/001/index.html より引用
# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep


## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#
bindkey -e
bindkey "^[[1~" beginning-of-line # Home gets to line head
bindkey "^[[4~" end-of-line # End gets to line end
bindkey "^[[3~" delete-char # Del

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete


## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=500000
SAVEHIST=500000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

## zsh editor
#
autoload zed


## Prediction configuration
#
#autoload predict-on
#predict-off


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color"
    ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"


## terminal configuration
#
case "${TERM}" in
screen)
    TERM=xterm
    ;;
esac

case "${TERM}" in
xterm|xterm-color|rxvt-unicode-256color)
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm-color)
    stty erase '^H'
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm)
    stty erase '^H'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
jfbterm-color)
    export LSCOLORS=gxFxCxdxBxegedabagacad
    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

# set terminal title including current directory
#
#case "${TERM}" in
#xterm|xterm-color|kterm|kterm-color)
#    precmd() {
#        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
#    }
#    ;;
#esac


## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine


## open file configure
alias -s zip=zipinfo

alias -s tgz=gzcat

alias -s gz="tar xvf"

alias -s tbz=bzcat

alias -s bz2=bzcat

alias -s txt=cat

alias -s xml=cat


alias -s html=firefox

alias -s xhtml=firefox


alias -s gif=display

alias -s jpg=display

alias -s jpeg=display

alias -s png=display

alias -s bmp=display


alias -s mp3=amarok

alias -s m4a=amarok

alias -s ogg=amarok


alias -s mpg=svlc

alias -s mpeg=svlc

alias -s avi=svlc

alias -s mp4v=svlc

# zmv
autoload -Uz zmv

##### プログラミング関連

export ALTERNATE_EDITOR=vim EDITOR=vim VISUAL=vim

# emacsclientの設定
#export ALTERNATE_EDITOR=emacs EDITOR=emacsclient VISUAL=emacsclient
# これらの拡張子のファイルをemacsでいきなり開けるようにする
#alias -s c=emacsclient -n
#alias -s c++=emacsclient -n
#alias -s h=emacsclient -n
#alias -s hpp=emacsclient -n
#alias -s hs=emacsclient -n
#alias -s rb=emacsclient -n
#alias -s py=emacsclient -n
#alias -s el=emacsclient -n

# chshできない環境向け
export SHELL=/bin/zsh

# PATH
export PATH=~/.bin:$PATH

# for screen
# auto launch
# test 'UNDEF' = ${STY-UNDEF} && exec screen -S main -xR

# autotime
REPORTTIME=3

for rc in `dirname $0`/module/*.zsh; do
  source $rc
done

# 最後に成功しておくことで、プロンプトを正常状態から開始
test 1 -eq 1
