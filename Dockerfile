FROM ubuntu:latest

# Make sure apt-get is up to date
RUN apt-get -y update
RUN sh -c echo -e '\Y' | apt-get install software-properties-common python-software-properties
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y update

# Grab the basic tools
RUN apt-get -y install git vim tmux fish
# A little more
RUN apt-get -y install sudo man


# Install dependencies
RUN apt-get -y install ctags make

RUN apt-get -y install python-pip python-dev build-essential
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv 

RUN pip install ansible


# ---------------- USER SETUP ----------------
# Setup User
RUN groupadd -r greg && useradd -r -g greg greg && echo "greg:greg" | chpasswd && adduser greg sudo
RUN mkdir -p /home/greg/ && chown greg:greg /home/greg/
RUN chown -R greg:greg /home/greg/
WORKDIR /home/greg/

# Set fish default shell for user
RUN usermod --shell `which fish` greg

# ---------------- Setup Dotfiles / Git ----------------
USER greg
ADD dev-setup.sh /home/greg/dev-setup.sh
RUN sh /home/greg/dev-setup.sh
RUN git config --global user.email "greg.steffensen88@gmail.com"
RUN git config --global user.name "greg1988"

# Setup Vundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/greg/.vim/bundle/Vundle.vim
ENV TERM=xterm-256color

# Run Vim plugin install
RUN echo -ne '\n' | vim +PluginInstall +qall