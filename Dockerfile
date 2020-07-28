# Galaxy - Vinyl

FROM bgruening/galaxy-stable:19.01

MAINTAINER Martina Alvera, martyalvera96@gmail.com

ENV GALAXY_CONFIG_BRAND="Vinyl"

RUN wget https://raw.githubusercontent.com/indigo-dc/Reference-data-galaxycloud-repository/master/elixir-italy.covacs.refdata/location/tool_data_table_conf.xml -O /etc/galaxy/tool_data_table_conf.xml

WORKDIR /galaxy-central

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

RUN wget https://raw.githubusercontent.com/Laniakea-elixir-it/Galaxy-flavours/master/galaxy-vinyl/tool-list.yaml -O $GALAXY_ROOT/tools1.yaml

RUN install-tools $GALAXY_ROOT/tools1.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf

#RUN install-tools $GALAXY_ROOT/tools2.yaml && \
#    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
#    rm /export/galaxy-central/ -rf

# Install workflows
#RUN mkdir -p $GALAXY_HOME/workflows

#RUN wget https://raw.githubusercontent.com/indigo-dc/Galaxy-flavors-recipes/master/galaxy-CoVaCS/galaxy-CoVaCS-workflows/Galaxy-Workflow-CoVaCS.ga -O $GALAXY_HOME/workflows/Galaxy-Workflow-CoVaCS.ga
#RUN wget https://raw.githubusercontent.com/indigo-dc/Galaxy-flavors-recipes/master/galaxy-CoVaCS/galaxy-CoVaCS-workflows/Galaxy-Workflow-covacs_wf_Select_variant.ga -O $GALAXY_HOME/workflows/Galaxy-Workflow-covacs_wf_Select_variant.ga

#RUN startup_lite && \
#    galaxy-wait && \
#    workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD
#TODO
#cvmfs configuration for elixir-italy.covacs.refdata
RUN wget https://raw.githubusercontent.com/indigo-dc/Reference-data-galaxycloud-repository/master/cvmfs_server_config_files/elixir-italy.covacs.refdata.conf -O /etc/cvmfs/config.d/elixir-italy.covacs.refdata.conf
RUN wget https://raw.githubusercontent.com/indigo-dc/Reference-data-galaxycloud-repository/master/cvmfs_server_keys/elixir-italy.covacs.refdata.pub -O /etc/cvmfs/keys/elixir-italy.covacs.refdata.pub
RUN echo "CVMFS_REPOSITORIES=elixir-italy.covacs.refdata" > /etc/cvmfs/default.local

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800
# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]
