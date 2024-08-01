FROM node:slim
ENV NODE_ENV=production
RUN mkdir -p /app
WORKDIR /app
COPY . .
RUN npm install
ENV PORT=8000
EXPOSE 8000
EXPOSE 9229
CMD ["npm", "start"]