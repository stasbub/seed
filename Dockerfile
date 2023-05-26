# Let's use the image base-notebook to build our image on top of it
FROM jupyter/datascience-notebook:latest
# Install in the default python3 environment
RUN pip install --quiet --no-cache-dir 'flake8==3.9.2' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

LABEL Stanislav Bubenchshikov <stasok2007@gmail.com>

#Let's define this parameter to install jupyter lab instead of the default juyter notebook command so we don't have to use it when running the container with the option -e
ENV JUPYTER_ENABLE_LAB=yes

COPY ./src /src
WORKDIR /src
