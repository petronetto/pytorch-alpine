FROM alpine:3.6

LABEL maintainer="Juliano Petronetto <juliano@petronetto.com.br>"
LABEL org.label-schema.name="PyTorch Alpine" \
      org.label-schema.description="PyTorch in Alpine Linux" \
      org.label-schema.url="https://hub.docker.com/r/petronetto/pytorch-alpine" \
      org.label-schema.vcs-url="https://github.com/petronetto/pytorch-alpine" \
      org.label-schema.vendor="Petronetto DevTech" \
      org.label-schema.version="1.0" \
      org.label-schema.schema-version="1.0"

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main | tee /etc/apk/repositories \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing | tee -a /etc/apk/repositories \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/community | tee -a /etc/apk/repositories \
    && apk add --update --no-cache tini bash \
        curl ca-certificates python3 py3-numpy py3-numpy-f2py libstdc++ \
## Setup de basic requeriments
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 --no-cache-dir install --upgrade pip setuptools \
    && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip; fi \
    && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
    && ln -s locale.h /usr/include/xlocale.h \
## Dev dependencies and others stuffs...
    && apk add --no-cache --virtual=.build-dependencies \
        build-base linux-headers python3-dev git cmake \
        libffi-dev openblas-dev py-numpy-dev \
    && pip install -U --no-cache-dir pyyaml pymkl cffi \
        ipywidgets notebook requests \
    && jupyter nbextension enable --py widgetsnbextension \
## Installing PyTorch
    && git clone --recursive https://github.com/pytorch/pytorch \
    && cd pytorch && python setup.py install \
## Cleaning
    && rm /usr/include/xlocale.h \
    && rm -rf /root/.cache \
    && rm -rf /var/cache/apk/* \
    && apk del .build-dependencies \
    && find /usr/lib/python3.6 -name __pycache__ | xargs rm -r \
    && rm -rf /root/.[acpw]* \
## Run notebook without token and disable warnings
    && mkdir -p /root/.jupyter \
    && echo "import warnings" >> /root/.jupyter/config.py \
    && echo "warnings.filterwarnings('ignore')" >> /root/.jupyter/config.py \
    && echo "c.NotebookApp.token = u''" >> /root/.jupyter/config.py

EXPOSE 5000

WORKDIR /notebooks

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["jupyter", "notebook", "--port=5000", "--no-browser", "--allow-root", "--ip=0.0.0.0", "--NotebookApp.token="]