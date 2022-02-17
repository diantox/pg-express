FROM node:16-bullseye

# Change to the Node.js user.
USER node

# Change to the PG Express directory.
WORKDIR /opt/pg-express

# Run BASH.
ENTRYPOINT ["/bin/bash"]
