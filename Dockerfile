# syntax=docker/dockerfile:1.4

FROM python:3.10 AS nonroot
RUN groupadd python_user && \
    useradd -mr -g python_user -s /sbin/nologin python_user
USER python_user
WORKDIR /home/python_user

FROM nonroot AS python-tools
RUN pip3 install --upgrade pip setuptools twine wheel

FROM python-tools AS deps-install
RUN --mount=type=bind,source=./requirements.txt,target=./requirements.txt pip3 install -r requirements.txt
