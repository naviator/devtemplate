if [ -f ~/.profile ]; then
    . ~/.profile
fi

__kube_prompt() {
    if [[ $(pwd) == $KUBE_REPO_DIR* ]];
    then
        echo "($(kubectl config current-context))"
    fi
}
KUBE_PROMPT="\$(__kube_prompt)"

export PS1="\e[0;32m[\u@\h \W]\$ \e[m "
PS1="$PS1${KUBE_PROMPT}\\\$ "
