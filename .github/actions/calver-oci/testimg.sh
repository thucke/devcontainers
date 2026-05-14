#!/bin/bash
export IMAGE_NAME=thucke/devcontainers/typo3-frankenphp
export image_basetag=php8.2-trixie
set -x


current_calver_major_minor=$(date "+%Y.%m")
last_imagecalvertag=$(skopeo list-tags --no-creds docker://ghcr.io/${IMAGE_NAME} | \
	jq -r --arg image_basetag "$image_basetag" '.Tags | sort_by(.) | [ .[] | select(.|startswith($image_basetag))]|[last][0]')
last_imagecalver=${last_imagecalvertag##*-}
if [[ ${last_imagecalver} == "${current_calver_major_minor}"* ]]; then
	current_patch_number=${last_imagecalver#${current_calver_major_minor}.}
	next_patch_number=$((current_patch_number + 1))
	export next_imagecalver="${current_calver_major_minor}.${next_patch_number}"
else
        export next_imagecalver="${current_calver_major_minor}.0"
fi
echo "next_imagecalver=${next_imagecalver}"
