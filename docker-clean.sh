#!/usr/bin/env sh

set -o errexit -o nounset

# j̶u̶m̶p̶ ̶t̶h̶e̶ ̶s̶h̶a̶r̶k̶, n̶u̶k̶e̶ ̶t̶h̶e̶ ̶f̶r̶i̶d̶g̶e̶, d̶r̶i̶n̶k̶ ̶t̶h̶e̶ ̶b̶l̶e̶a̶c̶h̶, cleanse the docker

# Please note that subshells have _not_ been quoted _on purpose_ to allow them to be uesd as list input
# shellcheck disable=SC2046

docker_cleanse() {
  ( [ "$(docker ps -q)" = '' ] && echo 'No containers running' ) || docker stop $(docker ps -q)

  ( [ "$(docker ps -qa)" = '' ] && echo 'No containers to delete' ) || docker rm $(docker ps -qa) 

  ( [ "$(docker images -qa)" = '' ] && echo 'No images to delete' ) || docker rmi -f $(docker images -qa)

  ( [ "$(docker volume ls -q)" = '' ] && echo 'No volumes to delete' ) || docker volume rm $(docker volume ls -q)

  ( [ "$(docker network ls --format "{{.ID}}\t{{.Name}}" | grep -vE '\b(bridge|host|none)\b' | cut -f 1)" = '' ] \
    && echo 'No networks to delete'
  ) || docker network rm $(docker network ls --format "{{.ID}}\t{{.Name}}" | grep -vE '\b(bridge|host|none)\b' | cut -f 1)

  # Check all is fresh and clean:

  ( 
    [ "$(docker ps -aq && docker images -aq && docker volume ls -q && docker network ls -q | wc -l)" = 3 ] \
    && echo 'Docker cleanse successful'
  ) || {
    echo 'Docker cleanse failed'
    exit 64
  }
}

if  [ -n "${BASH_SOURCE:-}" ] && [ "${BASH_SOURCE[0]}" != "${0}" ]; then
  export docker_cleanse
else
  docker_cleanse # "${@}"
  exit $?
fi
