# Step 1: Use Node image to build Angular app
FROM node:18-alpine AS build

WORKDIR /app

# Step 2: Install dependencies
COPY package*.json ./
RUN npm install

# Step 3: Copy the rest of the app files and build
COPY . .
RUN npm run build --prod

# Step 4: Use Nginx to serve the built app
FROM nginx:alpine

# Step 5: Copy the build output to Nginx's HTML directory
COPY --from=build /app/dist/sentiment-frontend /usr/share/nginx/html

# Step 6: Expose Nginx's default HTTP port
EXPOSE 80

# Step 7: Start Nginx
CMD ["nginx", "-g", "daemon off;"]
