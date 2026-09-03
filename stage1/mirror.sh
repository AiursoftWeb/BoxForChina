set -euo pipefail

MIRROR_SOURCE_PREFIX="${MIRROR_SOURCE_PREFIX:-pubhub.aiursoft.com/}"

mirror_image() {
    local image="$1"
    local source="${MIRROR_SOURCE_PREFIX:-}${image}"
    local target="localhost:8080/public_mirror/${image}"
    local platform="${MIRROR_PLATFORM:-linux/amd64}"
    local platform_os="${platform%%/*}"
    local platform_arch="${platform#*/}"
    local platform_digest
    local platform_image

    echo "Mirroring image: $image"
    sudo docker pull --platform "$platform" "$source"
    platform_digest="$(
        sudo docker manifest inspect --verbose "$source" |
            jq -er --arg os "$platform_os" --arg arch "$platform_arch" '
                if type == "array" then
                    first(.[] | select(
                        .Descriptor.platform.os == $os and
                        .Descriptor.platform.architecture == $arch
                    ) | .Descriptor.digest)
                else
                    .Descriptor.digest
                end
            '
    )"
    case "$platform_digest" in
        sha256:*) ;;
        *) echo "Failed to resolve $platform manifest digest for $image" >&2; return 1 ;;
    esac
    platform_image="${source}@${platform_digest}"
    sudo docker pull "$platform_image"
    sudo docker tag "$platform_image" "$target"
    sudo docker push "$target"
}

echo "Mirroring Ubuntu..."
mirror_image "ubuntu:26.04"

echo "Mirroring Caddy builder..."
mirror_image "caddy:builder"

echo "Mirroring Caddy latest..."
mirror_image "caddy:latest"

echo "Mirroring Python 3.11..."
mirror_image "python:3.11"
