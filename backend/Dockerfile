FROM node:16

# Initialize repos and upgrade the base system
COPY . /app

WORKDIR /app

RUN npm install

ENTRYPOINT [ "node", "app.js"]