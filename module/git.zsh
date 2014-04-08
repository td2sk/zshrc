alias st="git status"
alias co="git checkout"
alias lg="git log --pretty=format:\"[%Cblue%h%Creset] %Cgreen%s%Creset%C(red)%d%C(reset)\" --graph --color --date=short --all"
alias fix="git commit --amend"
alias dc="git diff --cached"
alias dw="git diff --color-words --word-diff-regex='\\w+|[^[:space:]]'"
alias dwl="git diff --color-words --word-diff-regex='\\w|[^[:space:]]'"
alias dcw="git diff --color-words --word-diff-regex='\\w+|[^[:space:]]' --cached"
alias dh="git diff HEAD~ HEAD"
alias dhw="git diff HEAD~ HEAD --color-words --word-diff-regex='\\w+|[^[:space:]]'"

function git-root(){
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  cd `pwd`/`git rev-parse --show-cdup`
fi
}
alias root="git-root"

function git-finish(){
  "git flow feature finish -rF `git rev-parse --abbrev-ref HEAD`"
}
alias finish_wx="git-finish"
