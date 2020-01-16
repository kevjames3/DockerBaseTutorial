FROM node:12-alpine

WORKDIR /usr/src/app

EXPOSE 80

COPY main.js .
COPY package*.json ./

RUN npm install

CMD ["node", "main.js"]
