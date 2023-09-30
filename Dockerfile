ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}
ENV DEBIAN_FRONTEND noninteractive

# Update the system
RUN apt-get update && apt-get upgrade -y

# Install OpenSSH Server
RUN apt-get install -y \
    ubuntu-server \
    openssh-server \
    curl \
    git \
    nano \
    sudo \
    bash-completion \
    iputils-ping

# Set up the server name
ARG SERVER_NAME=ubuntu
RUN echo ${SERVER_NAME} > /etc/hostname

# Set up configuration for SSH
RUN mkdir /var/run/sshd

# Uncomment if you need to use ROOT password for SSH
# RUN echo 'root:2222' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise, user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose the SSH port
EXPOSE 22
# Expose the HTTP port
EXPOSE 80

# Run SSH
CMD ["/usr/sbin/sshd", "-D"]

ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_NAME=user
RUN useradd -ms /bin/bash ${USER_NAME};
RUN groupmod --gid ${USER_GID} ${USER_NAME};
RUN usermod --uid ${USER_UID} --gid ${USER_GID} ${USER_NAME};
RUN echo ${USER_NAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER_NAME};
RUN chmod 0440 /etc/sudoers.d/${USER_NAME};
RUN mkdir /home/${USER_NAME}/.ssh
RUN curl https://github.com/${USER_NAME}.keys | tee -a /home/${USER_NAME}/.ssh/authorized_keys
RUN chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/
