FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl apt-transport-https gnupg ca-certificates \
  && curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" > /etc/apt/sources.list.d/microsoft-prod.list \
  && apt-get update \
  && ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV PATH="$PATH:/opt/mssql-tools18/bin"

COPY db-init.sh /db-init.sh
RUN chmod +x /db-init.sh

ENTRYPOINT ["/bin/bash","-lc"]
CMD ["/db-init.sh"]
