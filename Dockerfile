# BSD 3-Clause License

# Copyright (c) 2017, Juliano Petronetto
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.

# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.

# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM alpine:3.7

LABEL maintainer="Juliano Petronetto <juliano@petronetto.com.br>" \
      name="PyTorch Alpine" \
      description="PyTorch in Alpine Linux" \
      url="https://hub.docker.com/r/petronetto/pytorch-alpine" \
      vcs-url="https://github.com/petronetto/pytorch-alpine" \
      vendor="Petronetto DevTech" \
      version="1.0"

RUN apk add --upgrade -U apk-tools \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/main | tee /etc/apk/repositories \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing | tee -a /etc/apk/repositories \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/community | tee -a /etc/apk/repositories \
    && echo "|--> Install basics pre-requisites" \
    && apk add -U --no-cache tini bash \
        curl ca-certificates python3 py3-numpy py3-numpy-f2py \
        freetype jpeg libpng libstdc++ libgomp graphviz font-noto \
    && echo "|--> Install Python basics" \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 --no-cache-dir install --upgrade pip setuptools wheel \
    && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip; fi \
    && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
    && ln -s locale.h /usr/include/xlocale.h \
    && echo "|--> Install build dependencies" \
    && apk add -U --no-cache --virtual=.build-deps \
        build-base linux-headers python3-dev git cmake jpeg-dev \
        libffi-dev openblas-dev py-numpy-dev freetype-dev libpng-dev \
    && echo "|--> Install Python packages" \
    && pip install -U --no-cache-dir pyyaml pymkl cffi scikit-learn \
        matplotlib ipywidgets notebook requests pillow pandas seaborn \
    && echo "|--> Install PyTorch" \
    && git clone --recursive https://github.com/pytorch/pytorch \
    && cd pytorch && python setup.py install \
    && echo "|--> Install Torch Vision" \
    && git clone --recursive https://github.com/pytorch/vision \
    && cd vision && python setup.py install \
    && echo "|--> Cleaning" \
    && rm -rf /pytorch \
    && rm /usr/include/xlocale.h \
    && rm -rf /root/.cache \
    && rm -rf /var/cache/apk/* \
    && apk del .build-deps \
    && find /usr/lib/python3.6 -name __pycache__ | xargs rm -r \
    && rm -rf /root/.[acpw]* \
    && echo "|--> Configure Jupyter extension" \
    && jupyter nbextension enable --py widgetsnbextension \
    && mkdir -p ~/.ipython/profile_default/startup/ \
    && echo "import warnings" >> ~/.ipython/profile_default/startup/config.py \
    && echo "warnings.filterwarnings('ignore')" >> ~/.ipython/profile_default/startup/config.py \
    && echo "c.NotebookApp.token = u''" >> ~/.ipython/profile_default/startup/config.py \
    && echo "|--> Done!"

EXPOSE 5000

WORKDIR /notebooks

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["jupyter", "notebook", "--port=5000", "--no-browser", \
    "--allow-root", "--ip=0.0.0.0", "--NotebookApp.token="]