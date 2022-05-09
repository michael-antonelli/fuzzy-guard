#!/bin/bash

if [ $# -eq 0 ]; then
	echo "specify [--redhat --amazon --debian --ubuntu --alpine --oracle --fedora]"
	exit 1
fi

target=$1
shift

if [[ -z "${DOCKER_NETWORK}" ]]; then
	DOCKER_NETWORK_OPT=""
else
	DOCKER_NETWORK_OPT="--network ${DOCKER_NETWORK}"
fi


podman pull vuls/goval-dictionary
podman run --rm -it vuls/goval-dictionary version

# NOTE: fetches oval of the OS with security support enabled.
case "$target" in
	--redhat) podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch redhat ${@} 6 7 8
		;;
	--amazon) podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch amazon ${@}
		;;
	--debian) podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch debian ${@} 9 10 11
		;;
	--ubuntu) podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch ubuntu ${@} 14 16 18 20
		;;
	--alpine) podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch alpine ${@} 3.12 3.13 3.14 3.15
		;;
	--oracle) podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch oracle ${@}
		;;
	--fedora) podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch fedora ${@} 34 35
		;;
	--suse) podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch suse --suse-type suse-enterprise-server ${@} 12 15

		podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch suse --suse-type opensuse tumbleweed

		podman run --rm -it \
		${DOCKER_NETWORK_OPT} \
		-v $PWD:/goval-dictionary \
		vuls/goval-dictionary fetch suse --suse-type opensuse-leap 15.3
		;;
	--*)  echo "specify [--redhat --amazon --debian --ubuntu --alpine --oracle --fedora]"
		exit 1
		;;
	*) echo "specify [--redhat --amazon --debian --ubuntu --alpine --oracle --fedora]"
		exit 1
		;;
esac

exit 0

