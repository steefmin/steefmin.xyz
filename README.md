# steefmin.xyz

Personal portfolio. Can be found on [steefmin.xyz](https://www.steefmin.xyz). Powered by [Hugo](https://gohugo.io), with use of the [Freelancer theme](https://github.com/digitalcraftsman/hugo-freelancer-theme).

## Deployment

### Prerequisites
- Docker and Docker Compose installed on server
- Traefik running with network named `proxy`
- GitHub Personal Access Token with `read:packages` permission

### Initial Setup

1. **Authenticate with GitHub Container Registry on server:**
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u steefmin --password-stdin
   ```

2. **Copy `docker-compose.yml` to your server's compose directory**

3. **Start the container:**
   ```bash
   docker compose up -d steefmin-portfolio
   ```

### Updating the Site

When changes are pushed to the main branch, GitHub Actions automatically builds and pushes a new image. To deploy:

```bash
docker compose pull steefmin-portfolio
docker compose up -d steefmin-portfolio
```

### Monitoring

Check logs:
```bash
docker logs steefmin-portfolio -f
```

Check container status:
```bash
docker ps | grep steefmin-portfolio
```

