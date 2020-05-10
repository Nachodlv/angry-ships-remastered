FROM node

RUN mkdir -p /opt/app

WORKDIR /opt/app

COPY package.json .
RUN npm install --quiet

COPY . .

EXPOSE 3000

CMD npm run start   