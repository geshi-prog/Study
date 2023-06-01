FROM ubuntu:latest

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
    sudo \
    wget \
    curl \
    vim \
    tzdata \
    locales && \
    locale-gen ja_JP.UTF-8

# 日本語化
RUN locale-gen ja_JP.UTF-8
ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja

# vim設定
RUN echo '\n\
    set fenc=utf-8\n\
    set encoding=utf-8\n\
    set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8\n\
    set fileformats=unix,dos,mac\n\
    syntax on' >> /root/.vimrc

# パッケージをインストール
RUN apt-get install -y \
    build-essential \
    clisp \
    elixir \
    emacs \
    expect \
    git \
    libbz2-dev \
    libdb-dev \
    libffi-dev \
    libffi7 \
    libgdbm-dev \
    libgmp-dev \
    libgmp10 \
    liblzma-dev \
    libncurses-dev \
    libncurses5 \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtinfo5 \
    tk-dev \
    tree \
    uuid-dev \
    zlib1g-dev

##############
#  GO START  #
##############
# GOのバージョンを指定
ARG go_version="1.19.5"
# goをビルドする
RUN wget https://go.dev/dl/go${go_version}.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go${go_version}.linux-amd64.tar.gz
##############
#   GO END   #
##############

###################
#  haskell START  #
###################
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN stack setup
# ALIASを設定
RUN echo "alias ghci='stack ghci'" >> /root/.bashrc
RUN echo "alias ghc='stack ghc --'" >> /root/.bashrc
RUN echo "alias runghc='stack runghc --'" >> /root/.bashrc
###################
#   haskell END   #
###################

#################
#  JULIA START  #
#################
# juliaのバージョン(https://julialang.org/downloads/ からバージョンは確認する)
ARG julia_parent_version="1.8"
ARG julia_version="1.8.5"
# juliaをビルドする
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/${julia_parent_version}/julia-${julia_version}-linux-x86_64.tar.gz
RUN tar -C /usr/local -xzf julia-${julia_version}-linux-x86_64.tar.gz
#################
#   JULIA END   #
#################

##################
#  PYTHON START  #
##################
RUN cd /
# pythonのバージョン
ARG python_version="3.11.1"
# pythonをビルドする
RUN wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tar.xz
RUN tar xJf Python-${python_version}.tar.xz
RUN rm Python-${python_version}.tar.xz
RUN cd Python-${python_version}
RUN /Python-${python_version}/configure
RUN make
RUN make install
# pipのアップグレード
RUN python3 -m pip install --upgrade pip
# jupyter notebookのインストール
RUN python3 -m pip install notebook
# ALIASを設定
RUN echo 'alias python=python3' >> /root/.bashrc
RUN echo "alias pip='python3 -m pip'" >> /root/.bashrc
##################
#   PYTHON END   #
##################

################
#  RUST START  #
################
# rustをインストール
COPY install_rust.sh /root/
RUN sh /root/install_rust.sh
RUN /root/.cargo/bin/rustup default stable
################
#   RUST END   #
################

################
#  RUBY START  #
################
# rubyのバージョン
ARG ruby_version="3.1.2"
# rbenvをクローンする
RUN git clone --depth 1 https://github.com/rbenv/rbenv.git /root/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/bin/rbenv install ${ruby_version}
RUN /root/.rbenv/bin/rbenv global ${ruby_version}
RUN echo 'eval "$(/root/.rbenv/bin/rbenv init - bash)"' >> /root/.bashrc
################
#   RUBY END   #
################

#############
#  V START  #
#############
RUN cd / && git clone https://github.com/vlang/v
RUN cd /v && make
RUN /v/v symlink
#############
#   V END   #
#############

###############
#  LUA START  #
###############
RUN cd /
# luaのバージョン
ARG lua_version="5.4.6"
RUN wget http://www.lua.org/ftp/lua-${lua_version}.tar.gz
RUN tar xzf lua-${lua_version}.tar.gz
RUN cd lua-${lua_version} && make all test
###############
#   LUA END   #
###############

#################
#  SCALA START  #
#################
RUN cd /
RUN curl -fL https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz | gzip -d > cs
RUN chmod +x /cs
RUN /cs setup -y
# ALIASを設定
RUN echo 'alias scala="/cs launch scala"' >> /root/.bashrc
#################
#   SCALA END   #
#################

# PATHを通す
ARG program_path="export PATH=/:/lua-${lua_version}/src:/root/.rbenv/bin:/root/.cargo/bin/:/usr/local/go/bin:/root/.local/bin:/usr/local/julia-${julia_version}/bin/:$PATH"
RUN echo ${program_path} >> /root/.bashrc

# 作業ディレクトリを作成
RUN cd /root/ && git clone https://github.com/geshi-prog/Study.git
WORKDIR /root/Study
