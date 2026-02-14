set -euo pipefail

mirror_image() {
    local image="$1"
    local target="localhost:8080/public_mirror/${image}"

    echo "Mirroring image: $image"
    sudo docker pull "hub.aiursoft.com/$image"
    sudo docker tag "hub.aiursoft.com/$image" "$target"
    sudo docker push "$target"
}

echo "Mirroring Ubuntu..."
mirror_image "ubuntu:25.10"

echo "Mirroring Caddy builder..."
mirror_image "caddy:builder"

echo "Mirroring Caddy latest..."
mirror_image "caddy:latest"

