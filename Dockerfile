FROM ubuntu@sha256:786a8b558f7be160c6c8c4a54f9a57274f3b4fb1491cf65146521ae77ff1dc54

#[HARDWARE_CONFIG]: Deterministic execution and compilation flags
# Consolidated environment variables to reduce layer allocation overhead.
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    #For future uv/python instalation
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_CACHE_DIR=/tmp/.uv-cache \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_INSTALL_DIR=/opt/python

# Extract versions into environment variables for convenient future updates.
ENV CA_CERTS_VER="20240203" \
    NANO_VER="7.2-2ubuntu0.2" \
    UNZIP_VER="6.0-28ubuntu4.1" \
    CURL_VER="8.5.0-2ubuntu10.9" \
    WGET_VER="1.21.4-1ubuntu4.1" \
    XZ_UTILS_VER="5.6.1+really5.4.5-1ubuntu0.3" \
    FFMPEG_VER="7:6.1.1-3ubuntu5"

# [RUNTIME_ENVIRONMENT]: Deterministic APT Projection & Root Python Allocation
RUN set -ex && \
    # 1. Create a preferences.d file with strict version pinning
    { \
        echo "Package: ca-certificates"; \
        echo "Pin: version ${CA_CERTS_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: nano"; \
        echo "Pin: version ${NANO_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: unzip"; \
        echo "Pin: version ${UNZIP_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: curl"; \
        echo "Pin: version ${CURL_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: wget"; \
        echo "Pin: version ${WGET_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: xz-utils"; \
        echo "Pin: version ${XZ_UTILS_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: ffmpeg"; \
        echo "Pin: version ${FFMPEG_VER}"; \
        echo "Pin-Priority: 1001"; \
    } > /etc/apt/preferences.d/strict-pins && \
    \
    # 2. Update package lists and install strictly specified versions
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates=${CA_CERTS_VER} \
        nano=${NANO_VER} \
        unzip=${UNZIP_VER} \
        curl=${CURL_VER} \
        wget=${WGET_VER} \
        xz-utils=${XZ_UTILS_VER} \
        ffmpeg=${FFMPEG_VER} \
    && \
    # 3. Clean apt cache to reduce image size
    rm -rf /var/lib/apt/lists/* && \
    \
    # 4. Hold packages (protection against implicit dependency updates)
    apt-mark hold ca-certificates nano unzip curl wget xz-utils ffmpeg && \
    \
    # 5. Update certificates
    update-ca-certificates --fresh



CMD ["/bin/bash"]
#CMD ["sleep", "infinity"]



#mise prune
#mise install

#docker build --no-cache --progress=plain -t ubuntu-snapshot-i .
#docker run -it ubuntu-snapshot-i
# The --entrypoint /bin/bash flag overrides the default script execution.
# You get a Linux command line INSIDE the container.
#docker run -it --entrypoint /bin/bash ubuntu-snapshot-i



#docker tag ubuntu-snapshot-i alexberkovich/ubuntu-snapshot:2025-06-16
#docker tag ubuntu-snapshot-i alexberkovich/ubuntu-snapshot:latest
#docker push alexberkovich/ubuntu-snapshot:2025-06-16
#docker push alexberkovich/ubuntu-snapshot:latest


# Delete all containers
# docker rm -f $(docker ps -a -q)

# This command will only show the dangling images
# (images that are not tagged or referenced by any container)
# docker images -f "dangling=true"

# Delete all dangling images
# docker image prune -f

# Delete all unused images
# docker image prune -a -f

# Delete all images
# docker rmi -f $(docker images -q)

# Delete all build cache
# docker builder prune --all
# Verify builder cache deleted
# docker builder du

# https://gallery.ecr.aws/lambda/python/
# docker volume ls
# docker volume ls -q > volumes-to-delete.txt
# Review volumes-to-delete.txt and delete only anonymous or never be used one.
# xargs -r docker volume rm < volumes-to-delete.txt
## docker system prune --all
# docker rm -f ubuntu-snapshot
# docker rmi -f ubuntu-snapshot-i

# docker build --no-cache . -t ubuntu-snapshot-i
# docker build --no-cache --progress=plain . -t ubuntu-snapshot-i

# docker run --rm -it ubuntu-snapshot-i bash
# docker exec -it $(docker ps -q -n=1) bash

# sudo docker stats | sudo tee -a docker_stats.log
# sudo watch -n 15 "docker stats --no-stream | sudo tee -a docker_stats.log"
# RAM+SWAP memory
# watch -n 1 free -h


