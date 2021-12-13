FROM ubuntu:20.04

LABEL maintainer="Roman Schindlauer <romans@outlook.com>"

ARG DEBIAN_FRONTEND=noninteractive

ARG VERSION_CMAKE=3.16.5
ARG VERSION_NEOVIM=0.4.4
ARG VERSION_PLATFORMIO=5.1.0
ARG VERSION_PYNVIM=0.4.2

# get a few base packages first
RUN apt-get update && \
    apt-get -y install \
      build-essential \
      libssl-dev \
      wget \
      curl \
      git \
    && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# we need cmake for the YouCompleteMe vim plugin
# this build takes a long time
RUN wget https://github.com/Kitware/CMake/releases/download/v$VERSION_CMAKE/cmake-$VERSION_CMAKE.tar.gz && \
    tar -zxvf cmake-$VERSION_CMAKE.tar.gz && \
    cd cmake-$VERSION_CMAKE && \
    ./bootstrap && \
    make && \
    make install && \
    cd .. && \
    rm -rf cmake-$VERSION_CMAKE

# more packages now, so that we don't have to redo the slow cmake layer above
RUN apt-get update && \
    apt-get -y install \
      telnet \
      zsh \
      fzf \
      stow \
      python3-pip \
      python-is-python3 \
    && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# nvim appImage avoids Python issues of ubuntu package
RUN curl -LO https://github.com/neovim/neovim/releases/download/v$VERSION_NEOVIM/nvim.appimage && \
    chmod u+x nvim.appimage && \
    ./nvim.appimage --appimage-extract && \
    ln -s $(pwd)/squashfs-root/AppRun /usr/bin/nvim && \
    ln -s $(pwd)/squashfs-root/AppRun /usr/bin/vim && \
    mkdir -p /root/.config/nvim

RUN git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

RUN python -m pip install -U \
    platformio==$VERSION_PLATFORMIO \
    pynvim==$VERSION_PYNVIM

RUN mkdir -p /usr/local/etc/profile.d && \
    wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O /usr/local/etc/profile.d/z.sh

# start zsh as login shell, so .zprofile gets sourced
CMD ["zsh", "-l"]
