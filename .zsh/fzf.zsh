#!/usr/bin/env zsh

# From https://github.com/junegunn/fzf/wiki/examples

fvi() {
  local files=(${(ps:\n:)"$(fasd -Rfl "$@" | fzf --print0 -0 -1 -m --no-sort)"})
  [[ -n $files ]] && e -- $files
}

fcd() {
  local dir="$(fasd -Rdl "$@" | fzf --print0 -0 -1 +m --no-sort)" && cd -- $dir
}

facd() {
  local dir="$(fasd -Ral "$@" | fzf --print0 -0 -1 +m --no-sort)"
  if [[ -n $dir ]] then
     if [[ -d $dir ]] then
        cd -- $dir
     else
        cd -- ${dir:h}
     fi
  fi
}

fop() {
  local file="$(fasd -Rfl "$@" | fzf --print0 -0 -1 +m --no-sort)"
  [[ -n $file ]] && xdg-open $file
}

# fh - repeat history
runcmd (){ perl -e 'ioctl STDOUT, 0x5412, $_ for split //, <>' ; }

fh() {
  ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' | runcmd
}

# fhe - repeat history edit
writecmd (){ perl -e 'ioctl STDOUT, 0x5412, $_ for split //, do{ chomp($_ = <>); $_ }' ; }

fhe() {
  ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' | writecmd
}

rvi() {
  local files=(${(ps:\0:)"$(fzf --print0 -0 -1 --query="$1")"})
  [[ -n "$files" ]] && e -- $files
}

rcd() {
  local dir=$(find "${@:-.}" -path '*/.*' -prune -o -type d -print0 2> /dev/null | fzf --read0 --print0 -0 -1 +m) && cd $dir
}

rcda() {
  local dir=$(find "${@:-.}" -type d -print0 2> /dev/null | fzf --read0 --print0 -0 -1 +m) && cd "$dir"
}

rop() {
  local file="$(fzf --print0 --query="$1" -0 -1)"
  [[ -n "$file" ]] && xdg-open $file
}

lvi() {
  local files=(${(ps:\0:)"$(locate -Ai -0 ${@:-HOME} | grep -z -vE '~$' | fzf --read0 --print0 -0 -1 -m)"})
  [[ -n $files ]] && e -- $files
}

lcd() {
  local file="$(locate -Ai -0 ${@:-$HOME} | grep -z -vE '~$' | fzf --read0 --print0 -0 -1)"
  if [[ -n $file ]] then
     if [[ -d $file ]] then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}

lop() {
  local file="$(locate -Ai -0 ${@:-HOME} | fzf --read0 --print0 -0 -1)"
  [[ -n "$file" ]] && xdg-open $file
}
