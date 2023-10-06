FROM ubuntu:20.04

# Avoid timezone prompt
ARG TIMEZONE="Asia/Tokyo"
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# Install basic utilities
RUN apt-get update && \
    apt-get install -y python3.9 && \
    apt-get install -y --no-install-recommends build-essential curl ffmpeg ca-certificates  \
                                               libportaudio2 wget make unzip python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/bin/python3.9:$PATH
RUN ln -sf /usr/bin/python3.9 /usr/bin/python3
RUN ln -sf /usr/bin/python3.9 /usr/bin/python

# Install python packages
COPY age_unlearning/requirements.txt ./
COPY docker/requirements_ci.txt ./
RUN pip3 install --upgrade pip
RUN pip3 install torch --index-url https://download.pytorch.org/whl/cpu
RUN pip3 install -r requirements_ci.txt

WORKDIR /workspace
ENV PYTHONPATH "${PYTHONPATH}:/workspace/age_unlearning"

# Setup user and group ids
ARG USER_ID
ARG GROUP_ID
ARG AUX_GROUP_IDS=""

RUN \
  addgroup --gid "${GROUP_ID}" user && \
  adduser --disabled-password --uid "${USER_ID}" --gid "${GROUP_ID}" user && \
  echo "${AUX_GROUP_IDS}" | xargs -n1 echo | xargs -I% addgroup --gid % group% && \
  echo "${AUX_GROUP_IDS}" | xargs -n1 echo | xargs -I% usermod --append --groups group% user

CMD ["tail", "-f", "/dev/null"]

# Switch to non-root user
USER user
