# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Scott Cairns <scott-cairns@live.co.uk>"

# Set when building on Travis so that certain long-running build steps can
# be skipped to shorten build time.
ARG TEST_ONLY_BUILD

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# R packages including IRKernel which gets installed globally.
RUN conda install --quiet --yes \
    'rpy2=2.8*' \
    'r-base=3.4.1' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-tidyverse=1.1*' \
    'r-shiny=1.0*' \
    'r-rmarkdown=1.8*' \
    'r-forecast=8.2*' \
    'r-rsqlite=2.0*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-sparklyr=0.7*' \
    'r-htmlwidgets=1.0*' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Pick up Papermill for the anaconda environment
RUN conda install --quiet --yes \
	'papermill=0.14.2' \
	'runipy=0.1.5' \
	'autopep8=1.3.2' \
	'yapf=0.17.0' \
	'jupyter_contrib_nbextensions=0.5*' \
	'jupyter_nbextensions_configurator=0.4*'
	
RUN jupyter nbextension enable latex_envs/latex_envs --sys-prefix && \
	jupyter nbextension enable codefolding/main --sys-prefix && \
	jupyter nbextension enable code_prettify/code_prettify --sys-prefix && \
	jupyter nbextension enable collapsible_headings/main --sys-prefix && \
	jupyter nbextension enable highlight_selected_word/main --sys-prefix && \
	jupyter nbextension enable notify/notify --sys-prefix && \
	jupyter nbextension enable table_beautifier/main --sys-prefix && \
	jupyter nbextension enable codefolding/main --sys-prefix && \
	jupyter nbextension enable export_embedded/main --sys-prefix && \
	jupyter nbextension enable spellchecker/main --sys-prefix && \
	jupyter nbextension enable contrib_nbextensions_help_item/main --sys-prefix && \
	jupyter nbextension enable hide_input/main --sys-prefix && \
	jupyter nbextension enable code_font_size/code_font_size --sys-prefix && \
	jupyter nbextension enable hide_input_all/main --sys-prefix && \
	jupyter nbextension enable rubberband/main --sys-prefix && \
	jupyter nbextension enable toc2/main --sys-prefix && \
	jupyter nbextension enable varInspector/main --sys-prefix
