FROM golang:bookworm
ARG TARGETARCH
RUN apt-get update -y \
  && apt-get install --no-install-recommends -y \
  ca-certificates \
  unzip \
  jq \
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
  xcb \
  ffmpeg \
  imagemagick && \
  pip3 install --break-system-packages Xlib
RUN wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
  | gpg --dearmor \
  | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg && \
  echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
  | tee /etc/apt/sources.list.d/vscodium.list && \
  apt-get update -y && apt install -y codium && \
  ln -s /usr/bin/codium /usr/bin/code
# RUN case ${TARGETARCH} in arm64|arm/v8) CARCH="arm64" ;; amd64) CARCH="x64" ;; esac && \
#   curl -s -L -o vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-${CARCH}" && \
#   apt-get install -y ./vscode.deb && \
#   rm vscode.deb && \
#   rm -rf /var/lib/apt/lists/*
RUN curl -s -L -o jbmono.zip https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip && \
  unzip jbmono.zip "fonts/ttf/*" && \
  mv fonts/ttf/*.ttf /usr/share/fonts && \
  fc-cache -f && \
  rm -rf fonts jbmono.zip
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -ms /bin/bash codeuser
RUN usermod -aG sudo codeuser
RUN go install -v golang.org/x/tools/gopls@latest
USER codeuser
RUN code --no-sandbox \
  --install-extension golang.Go \
  --install-extension ms-python.python
WORKDIR /home/codeuser
RUN mkdir extensions
COPY --chown=codeuser:codeuser assets/vscode-user/* .config/VSCodium/User/
COPY --chown=codeuser:codeuser scripts/start_code_kiosk.sh .
COPY --chown=codeuser:codeuser scripts/makeshots .
RUN chmod a+x ./makeshots
COPY --chown=codeuser:codeuser scripts/waitvscode.py .
RUN chmod a+x ./waitvscode.py
RUN sed -i 's/\r$//' start_code_kiosk.sh
ARG RESOLUTION="1920x1080"
ENV X_RES="${RESOLUTION}"
ENV XVFB_RES="${RESOLUTION}x24+32"
ARG XARGS=""
ENV XVFB_ARGS="${XARGS}"
# Silence the go extension's welcome message
ENV CLOUD_SHELL="true"
ENTRYPOINT ["/bin/bash", "start_code_kiosk.sh"]
