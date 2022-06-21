# syntax=docker/dockerfile:1.4

FROM python:3.10-slim AS nonroot
RUN groupadd python_user && \
    useradd -mr -g python_user -s /sbin/nologin python_user
USER python_user
WORKDIR /home/python_user
ENV PATH="/home/python_user/.local/bin/:${PATH}"

FROM nonroot AS python-tools
USER root
RUN pip3 install --upgrade pip build setuptools twine wheel
USER python_user

FROM python-tools AS build
ARG PYTHON_PACKAGE_VERSION=1.0.0+dockerfiledefault
COPY --chown=python_user:python_user ./ ./code 
RUN cd code && \
    python3 -m build && \
    pip3 install dist/mypackage-${PYTHON_PACKAGE_VERSION}-py3-none-any.whl && \
    cd .. && \
    rm -rf code

FROM nonroot AS deploy
COPY --from=build /home/python_user/.local/bin/ /home/python_user/.local/bin/
COPY --from=build /home/python_user/.local/lib/python3.10/site-packages/ /home/python_user/.local/lib/python3.10/site-packages/ 
ENTRYPOINT ["mypackage"]
