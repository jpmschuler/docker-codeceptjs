FROM node:14-slim

# install node, unzip, ssh tools and ruby
RUN apt-get update && apt-get install -y \
    openssh-client git \
    chromium

RUN apt-get upgrade -y

RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN useradd -ms /bin/bash dockeruser
RUN npm config set prefix '/home/dockeruser/.npm-global'
RUN npm install -g npm@latest

USER dockeruser
WORKDIR /home/dockeruser

CMD /bin/bash