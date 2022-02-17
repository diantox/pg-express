FROM python:3.10-bullseye

# Install pgcli's dependencies.
RUN apt update
RUN apt install -y build-essential libpq-dev

# Create & run as the pgcli user.
RUN useradd --create-home --shell /bin/bash pgcli
USER pgcli

# Install pgcli.
RUN pip install --user pgcli

# Run BASH.
ENTRYPOINT ["/bin/bash"]
