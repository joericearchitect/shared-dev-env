 DIR="$(cd "$(dirname "$0")" && pwd)"

source $DIR/setenv-dev-env-local.sh

cd $DEV_ENV_VAGRANT_DIR

ssh vagrant@127.0.0.1 -p 2222
