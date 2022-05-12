if [ -f /etc/profile ]; then
    . /etc/profile
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

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

if [ -f $HOME/.project_profile ]; then
    . $HOME/.project_profile
fi

if [[ ! -z ${CHECKOUT_PROJECT+x} && ! -z ${PROJECT_DIR+x} && ! -d ${PROJECT_DIR} ]]; then
    mkdir -p "$(dirname -- "$(realpath -- "${PROJECT_DIR}")")"
    git clone --depth 1 ${CHECKOUT_PROJECT} ${PROJECT_DIR}
    cd ${PROJECT_DIR}
fi

if [[ ! -z ${PROJECT_DIR+x} && -d ${PROJECT_DIR} ]]; then
    cd ${PROJECT_DIR}
fi

echo 'For list of available aliases, type: "alias" [ENTER]'
