# Etapa 1: Build (Compilación de Vite)
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ENV VITE_API_DESPACHOS_URL=""
ENV VITE_API_VENTAS_URL=""
RUN npm run build

# Etapa 2: Run (Servidor Web Nginx)
FROM nginxinc/nginx-unprivileged:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf.template

ARG BACKEND_PRIVATE_IP
ENV BACKEND_IP=$BACKEND_PRIVATE_IP

USER root
RUN envsubst '${BACKEND_IP}' < /etc/nginx/conf.d/default.conf.template | sed -e 's/backend-app/'"$BACKEND_IP"'/g' > /etc/nginx/conf.d/default.conf
USER nginx

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]