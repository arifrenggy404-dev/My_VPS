FROM ubuntu:24.04

# Set environment variables untuk mencegah prompt interaktif
ENV DEBIAN_FRONTEND=noninteractive

# Update package manager dan install perkakas standar utilitas
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    nano \
    zip \
    unzip \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Tetapkan direktori kerja default
WORKDIR /workspace

# Jalankan terminal bash sebagai command default
CMD ["/bin/bash"]
