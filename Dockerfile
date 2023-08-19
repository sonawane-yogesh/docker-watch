FROM node:slim
ENV NODE_ENV=production
WORKDIR /app
COPY . ./
RUN npm install
EXPOSE 4000
CMD ["npm", "start"]