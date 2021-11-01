#!/bin/bash
set -e

if [[ "$1" == "magnetocoin-cli" || "$1" == "magnetocoin-tx" || "$1" == "magnetocoind" || "$1" == "test_magnetocoin" ]]; then
	mkdir -p "$MAGNETOCOIN_DATA"

	cat <<-EOF > "$MAGNETOCOIN_DATA/magnetocoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${MAGNETOCOIN_EXTRA_ARGS}
	EOF
	chown magnetocoin:magnetocoin "$MAGNETOCOIN_DATA/magnetocoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R magnetocoin "$MAGNETOCOIN_DATA"
	ln -sfn "$MAGNETOCOIN_DATA" /home/magnetocoin/.magnetocoin
	chown -h magnetocoin:magnetocoin /home/magnetocoin/.magnetocoin

	exec gosu magnetocoin "$@"
else
	exec "$@"
fi
