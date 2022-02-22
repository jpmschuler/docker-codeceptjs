FROM debian:stable-slim

RUN apt-get update && apt-get install -y gnupg curl

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

# install node, unzip, ssh tools and ruby
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        openssh-client git \
        chromium nodejs  && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN useradd -ms /bin/bash dockeruser
RUN npm config set prefix '/home/dockeruser/.npm-global'
RUN npm install -g npm@latest
RUN npm install -g pnpm fixpack

# add node-gyp and headers \
RUN export NODEVERSION=$(node --version); mkdir -p /home/root/node-headers/; curl -k -o /home/root/node-headers/node-${NODEVERSION}-headers.tar.gz -L https://nodejs.org/download/release/${NODEVERSION}/node-${NODEVERSION}-headers.tar.gz; npm config set tarball /home/root/node-headers/node-${NODEVERSION}-headers.tar.gz

USER dockeruser
RUN npx playwright install
WORKDIR /home/dockeruser
ENV PATH=/home/dockeruser/.npm-global/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD /bin/bash
