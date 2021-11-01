############################################################
# Dockerfile to build magnetocoind container images
# Based on Ubuntu
############################################################

FROM ubuntu:14.04
LABEL maintainer.0="cheezcharmer <cheezcharmer@cheezcharmer.org>"

RUN apt-get update
RUN apt-get install -y git make g++ python-leveldb libboost-all-dev libssl-dev libdb++-dev pkg-config libminiupnpc-dev wget xz-utils
RUN apt-get clean

RUN adduser magnetocoin --disabled-password
USER magnetocoin

WORKDIR /home/magnetocoin
RUN mkdir bin src
RUN echo PATH=\"\$HOME/bin:\$PATH\" >> .bash_profile

WORKDIR /home/magnetocoin/src
RUN git clone https://github.com/magnetocoin/magnetocoin-core.git magnetocoin

WORKDIR	/home/magnetocoin/src/magnetocoin/src
RUN make -f makefile.unix
RUN strip magnetocoind
RUN cp -f magnetocoind /home/magnetocoin/bin/
RUN make -f makefile.unix clean

WORKDIR	 /home/magnetocoin
RUN mkdir .magnetocoin
COPY magnetocoin.conf .magnetocoin/



ENV HOME /home/magnetocoin
EXPOSE 9550 9551 9999
USER magnetocoin
CMD [ "/home/magnetocoin/bin/magnetocoind" ]