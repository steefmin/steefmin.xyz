# Stage 1: Build the Hugo site
FROM hugomods/hugo:latest AS builder

# Set working directory
WORKDIR /src

# Copy the Hugo site source
COPY . .

# Build argument for baseurl (can be overridden at build time)
ARG HUGO_BASEURL=https://steefmin.xyz/

# Build the static site
RUN hugo --minify --baseURL="${HUGO_BASEURL}"

# Stage 2: Serve with Caddy
FROM caddy:2-alpine

# Create a non-root user to run Caddy
RUN addgroup -g 1000 caddy && \
    adduser -D -u 1000 -G caddy caddy && \
    chown -R caddy:caddy /usr/share/caddy /etc/caddy /config /data

# Copy the Caddyfile
COPY --chown=caddy:caddy Caddyfile /etc/caddy/Caddyfile

# Copy the built static site from the builder stage
COPY --from=builder --chown=caddy:caddy /src/public /usr/share/caddy

# Expose ports
EXPOSE 80
EXPOSE 443
EXPOSE 2019

# Set environment variable for site address (can be overridden at runtime)
ENV SITE_ADDRESS=:80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Switch to non-root user
USER caddy

# Caddy will automatically use the Caddyfile from /etc/caddy/Caddyfile
# No need to specify CMD as the base image handles it
