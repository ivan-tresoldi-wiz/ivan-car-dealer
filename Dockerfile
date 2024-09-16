# Use the official Alpine image as a base
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Install curl for healthcheck purposes
RUN apk add --no-cache curl

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies (prefer using npm ci for cleaner installs)
RUN npm ci --only=production

# If you have a build step, run it here
# RUN npm run build

# Copy the rest of the application code
COPY . .

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Change ownership of the application directory
RUN chown -R appuser:appgroup /usr/src/app

# Switch to the non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 3000

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

# Define the command to run the app
CMD ["node", "app.js"]