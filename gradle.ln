#! /usr/bin/env fish

set -l dc_dir $HOME/.dockervolumes
set -l gr_dir $dc_dir/.gradle

function mkd
  mkdir -p $argv
  if test -n "$SUDO_UID"
      chown $SUDO_UID:$SUDO_GID $argv
  end
end

mkd $dc_dir
mkd $gr_dir

docker run --rm -it -v $gr_dir:/home/gradle/.gradle -v "$PWD":/home/gradle/app -w /home/gradle/app ymmtmdk/gradle-kotlin $argv
