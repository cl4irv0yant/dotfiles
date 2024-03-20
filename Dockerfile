FROM archlinux:latest

RUN pacman -Syu --noconfirm \
	git \
	curl \
	vim \
	zsh \
	base-devel \
	sudo \
	&& pacman -Scc --noconfirm

RUN useradd -m -G wheel tester && \
	echo 'tester ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/tester

USER tester
WORKDIR /home/tester

RUN git clone https://your-repository-url.com/dotfiles.git

RUN cd dotfiles && ./install.sh

SHELL ["/bin/zsh", "-c"]
