FROM ubuntu:16.04

# Install R
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y --force-yes \
       libproj-dev \
       libgdal-dev \
       libxml2-dev \
       libssh2-1-dev \
       libcurl4-openssl-dev \
       r-base \
       r-base-dev \
       gdebi-core \
       wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up R
RUN echo 'options(repos=c(CRAN = "https://cran.rstudio.com/"), download.file.method="libcurl")' >> /etc/R/Rprofile.site

RUN R -e "install.packages('shiny', dependencies = TRUE)" \
    && R -e "install.packages('shinydashboard', dependencies = TRUE)" \
    && R -e "install.packages('shinyjs', dependencies = TRUE)" \
    && R -e "install.packages('rio', dependencies = TRUE)" \
    && R -e "install.packages('DT', dependencies = TRUE)" \
    && R -e "install.packages('urltools', dependencies = TRUE)"

# Download and install latest version of shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
   VERSION=$(cat version.txt) && \
   wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
   gdebi -n ss-latest.deb && \
   rm -f version.txt ss-latest.deb

# Set up Shiny server with single app
# only when this Dockerfile is used as a base.
EXPOSE 5000

ONBUILD RUN mkdir /srv/shiny-server/app
ONBUILD COPY . /srv/shiny-server/app
ONBUILD RUN . /srv/shiny-server/app
ONBUILD RUN echo "run_as shiny; \
             server { \
               listen 5000; \
               location / { \
                     app_dir /srv/shiny-server/app; \
                     directory_index off; \
                     log_dir /var/log/shiny-server; \
               } \
             }" > /etc/shiny-server/shiny-server.conf
ONBUILD RUN if [ -f /srv/shiny-server/app/shiny-server.conf ]; \
               then (>&2 echo "Using config file inside app directory") \
               && cp /srv/shiny-server/app/shiny-server.conf /etc/shiny-server/shiny-server.conf; \
               fi

ONBUILD WORKDIR /srv/shiny-server/app
ONBUILD CMD ["shiny-server"]
ONBUILD ENTRYPOINT ["./entrypoint.sh"]
