FROM cabanaonline/ubuntu-dev:1.0

LABEL base.image="cabanaonline/ubuntu-dev"
LABEL description="An R container with different libraries available for use."
LABEL maintainer="Alejandro Madrigal Leiva"
LABEL maintainer.email="me@alemadlei.tech"

ARG USER=cabana
ENV HOME /home/$USER

USER root

# Installs R.
RUN set -xe; \
    \
    apt-get install -y r-base-dev

# Builds nonpareil tool.
RUN set -xe; \
    \
    git clone git://github.com/lmrodriguezr/nonpareil.git && \
    cd nonpareil && \
    make && \
    make install;

# Installs other libraries.
RUN set -xe; \
    \
    echo "install.packages(c('vegan', 'tidyverse'), dependencies = TRUE, repos = 'http://cran.r-project.org/')" > install.r && \
    Rscript install.r && \
    rm install.r;

# Removes development tools.
RUN set -xe; \
    \
    cd /opt/scripts && ./uninstall.sh && \
    apt-get clean && \
    apt-get autoclean;


# Reverts to standard user.
USER cabana

# Entrypoint to keep the container running.
ENTRYPOINT ["tail", "-f", "/dev/null"]
