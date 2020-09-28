# Galaxy - Vinyl

FROM bgruening/galaxy-stable:20.05

MAINTAINER Martina Alvera, martyalvera96@gmail.com

ENV GALAXY_CONFIG_BRAND="Vinyl"

RUN apt-get update && apt-get upgrade -y

RUN apt-get install wget -y

RUN wget https://raw.githubusercontent.com/martinaalvera/docker-galaxy-vinyl/dev/tool_data_table_conf.xml -O /etc/galaxy/tool_data_table_conf.xml

WORKDIR /galaxy-central

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

RUN wget https://raw.githubusercontent.com/Laniakea-elixir-it/Galaxy-flavours/master/galaxy-vinyl/tool-list.yaml -O $GALAXY_ROOT/tools1.yaml

RUN /tool_deps/_conda/bin/conda update conda

RUN install-tools $GALAXY_ROOT/tools1.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf

# Install workflows
RUN mkdir -p $GALAXY_HOME/workflows

RUN wget https://raw.githubusercontent.com/Laniakea-elixir-it/Galaxy-flavours/master/galaxy-vinyl/workflow/Galaxy-Workflow-vinyl_annot_and_optimizer.ga -O $GALAXY_HOME/workflows/Galaxy-Workflow-vinyl_annot_and_optimizer.ga
RUN wget https://raw.githubusercontent.com/Laniakea-elixir-it/Galaxy-flavours/master/galaxy-vinyl/workflow/Galaxy-Workflow-vinyl_annot_and_survival.ga -O $GALAXY_HOME/workflows/Galaxy-Workflow-vinyl_annot_and_survival.ga

#TODO
#cvmfs configuration for elixir-italy.covacs.refdata
RUN wget https://raw.githubusercontent.com/indigo-dc/Reference-data-galaxycloud-repository/master/cvmfs_server_config_files/data.elixir-italy-cvmfs.conf -O /etc/cvmfs/config.d/data.elixir-italy-cvmfs.conf
RUN wget https://raw.githubusercontent.com/indigo-dc/Reference-data-galaxycloud-repository/master/cvmfs_server_keys/data.elixir-italy-cvmfs.pub -O /etc/cvmfs/keys/data.elixir-italy-cvmfs.pub
RUN echo "CVMFS_REPOSITORIES=data.elixir-italy-cvmfs" > /etc/cvmfs/default.local

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800
# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]
