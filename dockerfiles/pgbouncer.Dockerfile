FROM debian:bullseye

# Install PgBouncer.
RUN apt update
RUN apt install -y pgbouncer

# Create & run as the PgBouncer user.
RUN useradd --create-home --shell /bin/bash pgbouncer
USER pgbouncer

# Change to the PG Express directory.
WORKDIR /opt/pg-express

# Run BASH.
ENTRYPOINT ["/bin/bash"]
