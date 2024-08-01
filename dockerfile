FROM node:slim
ENV NODE_ENV=production
RUN mkdir -p /app
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 4000
EXPOSE 9229
CMD ["npm", "start"]