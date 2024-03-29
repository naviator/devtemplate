if [ -f ~/.profile ]; then
    . ~/.profile
fi

__kube_prompt() {
    if command -v kubectl &> /dev/null;
    then
        echo "($(kubectl config current-context))"
    fi
}
KUBE_PROMPT="\$(__kube_prompt)"

export PS1="\e[0;32m[\u@\h \W]\$ \e[m "
PS1="$PS1${KUBE_PROMPT}\\\$ "
