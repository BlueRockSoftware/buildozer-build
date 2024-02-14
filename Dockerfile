# Use Ubuntu 20.04 as base image
FROM ubuntu:20.04

ARG PYTHON_VER=3.10.13

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Install necessary system dependencies
RUN apt-get install -y \
    build-essential \
    python3-dev \
    python3-pip \
    python3-venv \
    libltdl-dev \
    openjdk-17-jdk \
    lld \
    git \
    sudo \
    unzip \
    zip \
    cmake \
    && apt-get clean

# Compile python from source
RUN apt-get install -y wget checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev && \
    cd /usr/src && \
    sudo wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz && \
    sudo tar xzf Python-${PYTHON_VER}.tgz && \
    cd Python-${PYTHON_VER} && \
    sudo ./configure --enable-optimizations && \
    sudo make install

# Install Python packages
RUN pip3 install wheel && \
    pip3 install setuptools==51.3.3 && \
    pip3 install buildozer==1.5.0 && \
    pip3 install Cython==0.29.26 && \
    pip3 install Kivy==2.1.0 && \
    pip3 install kivymd==1.1.1 && \
    pip3 install Pillow==8.4.0 && \
    pip3 install zeroconf==0.24.5

# Set arguments for non-root user
ARG USER=buildozer
ARG UID=1001
ARG GID=1001

# Create non-root user, add to sudoers and set as owner of /workdir
RUN addgroup --gid "$GID" "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "$USER" \
    --uid "$UID" \
    "$USER"

RUN ln -s /usr/local/bin/python3 /usr/local/bin/python
RUN ln -s /usr/local/bin/pip3 /usr/local/bin/pip
RUN pip3 install --upgrade pip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
