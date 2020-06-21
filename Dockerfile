FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    bat \
    binutils \
    bison \
    clang \
    cscope \
    ctags \
    curl \
    default-jdk \
    emacs \
    fd-find \
    fish \
    flex \
    fzf \
    g++ \
    gcc \
    gdb \
    git \
    grub2 \ 
    htop \
    language-pack-en \
    locate \
    make \
    neovim \
    netcat \
    perl \
    python3 \
    python3-pip \
    silversearcher-ag \
    software-properties-common \
    ssh \
    tig \
    tmux \
    xorriso \ 
    xxd 

# for powerline
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN add-apt-repository -y ppa:lazygit-team/release && apt-get update && apt-get install -y fonts-powerline lazygit

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 && \	
    apt-get update && \
    apt-get install -y sbt

RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN git clone https://github.com/khale/neovim-config && mkdir -p /root/.config/nvim && mv neovim-config/init.vim /root/.config/nvim/ && rm -rf neovim-config

# install nvim plugins before I get in
RUN nvim --headless +PlugInstall +qall
RUN git clone https://github.com/khale/dotfiles && mkdir -p /root/.config/fish && mv dotfiles/fish-config /root/.config/fish/config.fish && mv dotfiles/gitnow-config ~/.gitflow
RUN git clone https://github.com/khale/fisher-config && mv fisher-config/fishfile /root/.config/fish/ && rm -rf fisher-config
RUN git clone https://github.com/khale/.tmux && ln -s -f .tmux/.tmux.conf  /root/.tmux.conf && cp .tmux/.tmux.conf.local /root

# Verilator
RUN git clone http://git.veripool.org/git/verilator && \
    cd verilator && \
    git pull && \
    git checkout v4.016 && \
    autoconf && \
    ./configure && \
    make -j12 && \
    make install

WORKDIR /hack

CMD ["/usr/bin/fish"]

