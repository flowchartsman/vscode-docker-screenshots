FROM debian:buster-slim
WORKDIR /usr/bin
RUN apt-get update -y \
  && apt-get install --no-install-recommends -y \
  ca-certificates \
  gnupg \
  matchbox \
  xvfb libgl1-mesa-dri \
  sudo \
  curl \
  xdotool \
  scrot \
  python3 \
  imagemagick && \
  curl -s -L -o vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64' && \
  apt-get install -y ./vscode.deb && \
  rm vscode.deb && \
  rm -rf /var/lib/apt/lists/*
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -ms /bin/bash codeuser
RUN usermod -aG sudo codeuser
USER codeuser
WORKDIR /home/codeuser
COPY --chown=codeuser:codeuser scripts/start_code_kiosk.sh .
COPY --chown=codeuser:codeuser scripts/getshots.py .
RUN chmod a+x ./getshots.py
RUN sed -i 's/\r$//' start_code_kiosk.sh
ARG RESOLUTION="1920x1080x24+32"
ENV XVFB_RES="${RESOLUTION}"
ARG XARGS=""
ENV XVFB_ARGS="${XARGS}"
ENTRYPOINT ["/bin/bash", "start_code_kiosk.sh"]
#ENTRYPOINT ["/bin/bash"]
