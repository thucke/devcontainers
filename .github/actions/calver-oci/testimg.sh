#!/bin/bash
export IMAGE_NAME=thucke/devcontainers/typo3-frankenphp
export image_basetag=php8.2-trixie
set -x
last_imagecalvertag=$(skopeo list-tags --no-creds docker://ghcr.io/${IMAGE_NAME} | \
            jq -r --arg image_basetag "$image_basetag" '.Tags | sort_by(.) | [ .[] | select(.|startswith($image_basetag))]|[last][0]')
last_imagecalver=${last_imagecalvertag##*-}
last_imagecalver_vlaue=$((last_imagecalver))
next_imagecalver=$((last_imagecalver + 1))
echo "next_imagecalvertag=${image_basetag}-${next_imagecalver}"
