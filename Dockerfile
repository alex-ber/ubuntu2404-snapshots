FROM ubuntu@sha256:008173c23f95b170204355c12626cb5a965d779a7e1283b09e9cffbb1bf33ca3

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
ENV CA_CERTS_VER="20260601~24.04.1" \
    PERL_BASE_VER="5.38.2-3.2ubuntu0.6" \
    LIBSSL3T64_BASE_VER="3.0.13-0ubuntu3.16" \
    NANO_VER="7.2-2ubuntu0.2" \
    GCC_VER="4:13.2.0-7ubuntu1" \
    GPP_VER="4:13.2.0-7ubuntu1" \
    PYTHON3_DEV_VER="3.12.3-0ubuntu2.1" \
    UNZIP_VER="6.0-28ubuntu4.1" \
    CURL_VER="8.5.0-2ubuntu10.15" \
    WGET_VER="1.21.4-1ubuntu4.5" \
    XZ_UTILS_VER="5.6.1+really5.4.5-1ubuntu0.3" \
    FFMPEG_VER="7:6.1.1-3ubuntu5" \
    TEXLIVE_XETEX_VER="2023.20240207-1" \
    TEXLIVE_FONTS_RECOMMENDED_VER="2023.20240207-1" \
    TEXLIVE_LANG_CYRILLIC_VER="2023.20240207-1" \
    TEXLIVE_LATEX_EXTRA_VER="2023.20240207-1" \
    FONTS_DEJAVU_VER="2.37-8" \
    FONTS_FREEFONT_OTF_VER="20211204+svn4273-2" \
    LMODERN_VER="2.005-1"


# [RUNTIME_ENVIRONMENT]: Deterministic APT Projection & Root Python Allocation
RUN set -ex && \
    # 1. Create a preferences.d file with strict version pinning
    { \
        echo "Package: ca-certificates"; \
        echo "Pin: version ${CA_CERTS_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: perl-base"; \
        echo "Pin: version ${PERL_BASE_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo "Package: libssl3t64"; \
        echo "Pin: version ${LIBSSL3T64_BASE_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: nano"; \
        echo "Pin: version ${NANO_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: gcc"; \
        echo "Pin: version ${GCC_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: g++"; \
        echo "Pin: version ${GPP_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: python3-dev"; \
        echo "Pin: version ${PYTHON3_DEV_VER}"; \
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
        echo ""; \
        echo "Package: texlive-xetex"; \
        echo "Pin: version ${TEXLIVE_XETEX_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: texlive-fonts-recommended"; \
        echo "Pin: version ${TEXLIVE_FONTS_RECOMMENDED_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: texlive-lang-cyrillic"; \
        echo "Pin: version ${TEXLIVE_LANG_CYRILLIC_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: texlive-latex-extra"; \
        echo "Pin: version ${TEXLIVE_LATEX_EXTRA_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: fonts-dejavu"; \
        echo "Pin: version ${FONTS_DEJAVU_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo ""; \
        echo "Package: fonts-freefont-otf"; \
        echo "Pin: version ${FONTS_FREEFONT_OTF_VER}"; \
        echo "Pin-Priority: 1001"; \
        echo "Package: lmodern"; \
        echo "Pin: version ${LMODERN_VER}"; \
        echo "Pin-Priority: 1001"; \
    } > /etc/apt/preferences.d/strict-pins && \
    \
    # 2. Update package lists and install strictly specified versions
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates=${CA_CERTS_VER} \
        perl-base=${PERL_BASE_VER} \
        libssl3t64=${LIBSSL3T64_BASE_VER} \
        nano=${NANO_VER} \
        gcc=${GCC_VER} \
        g++=${GPP_VER} \
        python3-dev=${PYTHON3_DEV_VER} \
        unzip=${UNZIP_VER} \
        curl=${CURL_VER} \
        wget=${WGET_VER} \
        xz-utils=${XZ_UTILS_VER} \
        ffmpeg=${FFMPEG_VER} \
        texlive-xetex=${TEXLIVE_XETEX_VER} \
        texlive-fonts-recommended=${TEXLIVE_FONTS_RECOMMENDED_VER} \
        texlive-lang-cyrillic=${TEXLIVE_LANG_CYRILLIC_VER} \
        texlive-latex-extra=${TEXLIVE_LATEX_EXTRA_VER} \
        fonts-dejavu=${FONTS_DEJAVU_VER} \
        fonts-freefont-otf=${FONTS_FREEFONT_OTF_VER} \
        lmodern=${LMODERN_VER} \
    && \
    # 3. Clean apt cache to reduce image size
    rm -rf /var/lib/apt/lists/* && \
    \
    # 4. Hold packages (protection against implicit dependency updates)
    apt-mark hold ca-certificates perl-base libssl3t64 nano gcc g++ python3-dev unzip curl wget xz-utils ffmpeg texlive-xetex texlive-fonts-recommended  \
                  texlive-lang-cyrillic texlive-latex-extra fonts-dejavu fonts-freefont-otf lmodern && \
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



#docker tag ubuntu-snapshot-i alexberkovich/ubuntu2404-snapshot:2026-10-01
#docker tag ubuntu-snapshot-i alexberkovich/ubuntu2404-snapshot:latest
#docker push alexberkovich/ubuntu2404-snapshot:2026-10-01
#docker push alexberkovich/ubuntu2404-snapshot:latest

##docker system prune --all
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


