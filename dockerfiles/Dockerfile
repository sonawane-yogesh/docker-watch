FROM node:slim
ENV NODE_ENV=production
WORKDIR /app
COPY . ./
RUN npm install
# EXPOSE 8080
ENV NODE_ENV=production
WORKDIR /app
COPY . ./
RUN npm install
EXPOSE 4000
# EXPOSE 9229
CMD ["npm", "start"]
# CMD ["npm", "run", "debug"]