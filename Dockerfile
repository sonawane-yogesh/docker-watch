FROM node:slim
ENV NODE_ENV=production
# RUN mkdir -p /home/app
WORKDIR /app
COPY . ./
RUN npm install
EXPOSE 4000
CMD [ "npm", "start"]