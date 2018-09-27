FROM ubuntu:18.04

# Setup a tools directory
WORKDIR /home/dev

RUN apt-get update && apt-get install -y \
      build-essential \
      curl \
      gcc \
      gdb \
      gnupg \
      make \
      minicom \
      openocd \
      software-properties-common \
      wget \
      --no-install-recommends \
      && rm -rf /var/lib/apt/lists/*

# Add the git repo
RUN add-apt-repository ppa:git-core/ppa

# Add LLVM 6.0 repo
RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" > /etc/apt/sources.list.d/llvm.list
# Add the keys
RUN curl -sSL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

# Add the Glide repo

# Add RVM repo
RUN cd /tmp \
      && wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz \
      && tar -xzvf ruby-install-0.5.0.tar.gz \
      && cd ruby-install-0.5.0 \
      && make install \
      && ruby-install ruby 1.9.3-p194 \
      # Install bundler globally
      && PATH=/opt/rubies/ruby-1.9.3-p194/bin:$PATH gem install bundler \
      && rm -rf /tmp/*

# Install all these things
RUN apt-get update && apt-get install -y \
      clang-6.0 \
      clang-tools-6.0 \
      clang-6.0-doc \
      clang-format-6.0 \
      libclang-common-6.0-dev \
      libclang-6.0-dev \
      libclang1-6.0 \
      libfuzzer-6.0-dev \
      git \
      python-clang-6.0 \
      --no-install-recommends \
      && rm -rf /var/lib/apt/lists/*

# Set Clang alternatives
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 1000 \
      && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 1000

# Download the GCC ARM toolchain from ARM developer site
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 -O gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 \
      && tar xvf gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 \
      && rm gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2

# Set up the compiler path
ENV PATH $PATH:/home/dev/gcc-arm-none-eabi-6-2017-q2-update/bin
ENV PATH $PATH:/opt/rubies/ruby-1.9.3-p194/bin

# Set the project directory
WORKDIR /home/projects
