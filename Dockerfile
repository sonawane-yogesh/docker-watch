FROM node:slim
ENV NODE_ENV=production
WORKDIR /app
COPY . ./
RUN npm install
EXPOSE 8080
CMD ["npm", "start"]