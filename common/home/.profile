if [ -f /etc/profile ]; then
    . /etc/profile
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

if [ -f ${HOME}/.env ]; then
    source ${HOME}/.env
fi

alias ks='ARG=$(kubectl config get-contexts -o=name | fzf); if [ -n "$ARG" ]; then kubectl config use-context $ARG; fi'

if [ ! -d ~/.ssh ]; then
    echo "Creating folder .ssh"
    mkdir ~/.ssh && chmod 700 ~/.ssh
    echo "Testing .ssh write permissions"
    touch ~/.ssh/test && rm ~/.ssh/test
fi

init_gcloud_connect () {
    echo "Reconnecting..."
    gcloud auth login --no-launch-browser
    gcloud auth application-default login --no-launch-browser
}

export CLOUDSDK_PYTHON=/usr/bin/python3.7
export PATH=$PATH:/usr/lib/google-cloud-sdk/bin/

# scp must have no output from .profile
[[ $- == *i* ]] || return

if [ -f $HOME/.project_profile ]; then
    . $HOME/.project_profile
fi

if [[ ! -z ${CHECKOUT_PROJECT+x} && ! -z ${PROJECT_DIR+x} && ! -d ${PROJECT_DIR} ]]; then
    PROJECT_DIR_PARENT="$(dirname -- "${PROJECT_DIR}")"
    echo "Creating ${PROJECT_DIR_PARENT}"
    mkdir -p "${PROJECT_DIR_PARENT}"
    git clone ${CHECKOUT_PROJECT} ${PROJECT_DIR}
fi

if [[ ! -z ${PROJECT_DIR+x} && -d ${PROJECT_DIR} ]]; then
    cd ${PROJECT_DIR}
fi
