FROM postgres:latest
MAINTAINER JBPadgett <@jbpadgett>
ENV REFRESHED_AT 09-27-2015

# Most logic of postgres db setup is in official postgres docker image

# Optional initial DB setups run as shell scripts from /docker-entrypoint-initdb.d/
ADD db_setup_script_pg_image.sh /docker-entrypoint-initdb.d/

# Optional sql imports from backups
#ADD db_sql_import.sh /docker-entrypoint-initdb.d/
#ADD latestdbdump.sql.zip /tmp/latestdbdump.sql.zip


