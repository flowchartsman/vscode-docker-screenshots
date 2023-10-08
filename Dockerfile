FROM golang:bookworm
ARG TARGETARCH
WORKDIR /usr/bin
RUN apt-get update -y \
  && apt-get install --no-install-recommends -y \
  ca-certificates \
  gnupg \
  matchbox \
  xauth \
  xvfb libgl1-mesa-dri \
  sudo \
  curl \
  xdotool \
  scrot \
  python3 \
  python3-pip \
  imagemagick && \
  pip3 install --break-system-packages Xlib
RUN  curl -s -L -o vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-$TARGETARCH" && \
  apt-get install -y ./vscode.deb && \
  rm vscode.deb && \
  rm -rf /var/lib/apt/lists/*
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -ms /bin/bash codeuser
RUN usermod -aG sudo codeuser
USER codeuser
RUN go install -v golang.org/x/tools/gopls@latest
RUN code --no-sandbox --install-extension golang.Go --install-extension ms-python.python
WORKDIR /home/codeuser
RUN mkdir extensions
COPY --chown=codeuser:codeuser assets/vscode-user/* .code-init/
COPY --chown=codeuser:codeuser scripts/start_code_kiosk.sh .
COPY --chown=codeuser:codeuser scripts/makeshots .
RUN chmod a+x ./makeshots
COPY --chown=codeuser:codeuser scripts/waitvscode.py .
RUN chmod a+x ./waitvscode.py
RUN sed -i 's/\r$//' start_code_kiosk.sh
ARG RESOLUTION="1920x1080x24+32"
ENV XVFB_RES="${RESOLUTION}"
ARG XARGS=""
ENV XVFB_ARGS="${XARGS}"
# Silence the go extension's welcome message
ENV CLOUD_SHELL="true"
ENTRYPOINT ["/bin/bash", "start_code_kiosk.sh"]
