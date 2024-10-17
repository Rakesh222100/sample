# Stage 1: Build the Angular application
FROM node:16-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Increase npm timeout and install dependencies
RUN npm config set timeout 120000 && npm install --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the Angular application
RUN npm run build --prod

# Stage 2: Serve the application using NGINX
FROM nginx:alpine

# Copy the built Angular app from the previous stage to the NGINX directory
COPY --from=build /app/dist/sample-angular-app /usr/share/nginx/html

# Expose the port that NGINX will use
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
