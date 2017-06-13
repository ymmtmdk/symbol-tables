set -l dc_dir $HOME/.dockervolumes
set -l gr_dir $dc_dir/.ivy2
set -l sb_dir $dc_dir/.sbt

function mkd
  mkdir -p $argv
  if test -n "$SUDO_UID"
      chown $SUDO_UID:$SUDO_GID $argv
  end
end

mkd $dc_dir
mkd $gr_dir
mkd $sb_dir

docker run --rm -it -v $sb_dir:/home/worker/.sbt -v $gr_dir:/home/worker/.ivy2 -v "$PWD":/home/worker/app -w /home/worker/app ymmtmdk/sbt $argv
