# set the bash command line editing mode
set -o vi
ulimit -n 1024

export SVN_EDITOR=vi
export CLICOLOR=true
export LSCOLORS=Gxfxcxdxbxegedabagacad

export JAVA_HOME=`/usr/libexec/java_home -v1.7`
export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=128m"

export PATH=$PATH:~/bin:/usr/local/mongodb/bin:/usr/local/jmeter/bin:$JAVA_HOME/bin
export PS1="$ "
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#function to quickly get ip addresses
function myip () {
    local en0=`ipconfig getifaddr en0`
    local en1=`ipconfig getifaddr en1`
    local en3=`ipconfig getifaddr en3`
    if [ -n "$en0" ]; then echo "ethernet: $en0"; fi
    if [ -n "$en1" ]; then echo "wireless: $en1"; fi
    if [ -n "$en3" ]; then echo "thunderbolt: $en3"; fi

    local ext=`dig +short myip.opendns.com @resolver1.opendns.com 2> /dev/null`
    if [ $? == 0 -a -n "$ext" ]; then echo "external: $ext"; fi

    if [ -z "$en0$en1$en3$ext" ]; then echo "no connectivity"; fi
}

#aliases
alias v=vagrant
#alias ls='ls -G'
alias www="python -m SimpleHTTPServer"
alias mvn-help="cat ~/bin/mvn-help.txt"
alias idea-clean="rm -rf *.iml */*.iml .idea/"
alias vsh="pushd .>/dev/null;cd ~/src/utilities/vagrant;vagrant ssh;popd>/dev/null"

alias jirash='$HOME/opt/jirash/bin/jirash'      # or whatever
complete -C 'jirash --bash-completion' jirash   # bash completion

alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias path="echo $PATH | sed -e 's/:/\\
/g'"

alias jetty="java -Xmx512m -XX:MaxPermSize=256m -jar /usr/local/jetty-runner.jar"
alias serve="python -m SimpleHTTPServer"

export MARKPATH=$HOME/.marks
function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null && pwd || echo "No such mark: $1"
}
function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
    rm -i "$MARKPATH/$1"
}
function marks {
    #ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
    #mac osx
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%s -> %s\n", $1, $2}'
}

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  #local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  #mac osx
  local wordlist=$(find $MARKPATH -type l -exec basename {} \;)
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark

# don't check .profile_private into dotfiles
. .profile_private
