# Stage 1: Build
FROM node:20-slim as build-stage

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Production
FROM nginx:stable-alpine

# Copiem fisierele compilate din prima etapa in folderul de Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
