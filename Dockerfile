FROM java:7

# Create a directory for liquibase
RUN mkdir /opt/liquibase

# Download and unpack the distribution
WORKDIR /opt/liquibase
RUN curl -L https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.3.3/liquibase-3.3.3-bin.tar.gz | tar xz
RUN chmod +x /opt/liquibase/liquibase
RUN ln -s /opt/liquibase/liquibase /usr/local/bin/

# Get the postgres JDBC driver from http://jdbc.postgresql.org/download.html
#RUN mkdir /opt/jdbc_drivers
#WORKDIR /opt/jdbc_drivers
ADD https://jdbc.postgresql.org/download/postgresql-9.4-1204.jdbc4.jar /opt/jdbc_drivers/
RUN ln -s /opt/jdbc_drivers/postgresql-9.4-1204.jdbc4.jar /usr/local/bin/


ADD scripts/liquibase_update.sh /usr/bin/liquibase_update
RUN chmod +x /usr/bin/liquibase_update

ADD scripts/liquibase_destroy.sh /usr/bin/liquibase_destroy
RUN chmod +x /usr/bin/liquibase_destroy

WORKDIR /

ENTRYPOINT ["/bin/bash"]
