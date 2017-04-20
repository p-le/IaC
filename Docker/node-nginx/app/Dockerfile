FROM node:7.9.0-alpine
MAINTAINER phu.le.dev@gmail.com

ENV PORT 8080
WORKDIR /app
COPY . /app

RUN yarn install --production

ENTRYPOINT ["yarn", "start"]
