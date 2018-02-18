FROM ubuntu:latest

# Make sure apt-get is up to date
RUN apt-get -y update

# Grab the basic tools
RUN apt-get -y install git vim tmux fish
# A little more
RUN apt-get -y install sudo man

# Install dependencies
RUN yes | apt-get install \
    ctags \
    make \
    python \
    python-dev


# ---------------- USER SETUP ----------------
# Setup User
RUN groupadd -r greg && useradd -r -g greg greg && echo "greg:greg" | chpasswd && adduser greg sudo
RUN mkdir -p /home/greg/ && chown greg:greg /home/greg/

# Setup editor diretory
VOLUME /home/greg/dotfiles ./dev-env
COPY ./dev-env /home/greg/dotfiles

USER greg
RUN bash /home/greg/dotfiles/docker-startup.sh
USER root

# Setup Vundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/greg/.vim/bundle/Vundle.vim

# Permissions / final tweaks
RUN chown -R greg:greg /home/greg/
WORKDIR /home/greg/

ENV TERM=xterm-256color

USER greg
RUN echo -ne '\n' | vim +PluginInstall +qall
USER root

# Setup Fish
RUN usermod --shell `which fish` greg

USER greg