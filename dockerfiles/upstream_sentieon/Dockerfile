FROM 4dndcic/ubuntu16.04-miniconda-python36:v1
MAINTAINER Michele Berselli (berselli.michele@gmail.com), Phil Grayson (phil.d.grayson@gmail.com)

# general updates & installing necessary Linux components
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    gcc \
    g++ \
    git \
    less \
    libncurses-dev \
    make \
    time \
    zip \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    liblz4-tool \
    libbz2-dev \
    liblzma-dev \
    locales \
    parallel \
    autoconf \
    autogen \
    autotools-dev \
    automake \
    pkg-config \
    tabix \
    yasm \
    libdbi-perl \
    libmodule-build-perl \
    libarchive-zip-perl \
    libmysqlclient-dev \
    libpng-dev \
    libexpat1-dev

WORKDIR /usr/local/bin

# conda & python libraries
RUN conda install -c bioconda -y python=3.6.8 && \
    conda clean -a -y -f

# sentieon
RUN wget https://s3.amazonaws.com/sentieon-release/software/sentieon-genomics-202010.02.tar.gz && \
    tar -xzvf sentieon-genomics-202010.02.tar.gz && \
    ln -s sentieon-genomics-202010.02 sentieon

# env paths
ENV PATH=/usr/local/bin/sentieon/bin/:$PATH

# supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]