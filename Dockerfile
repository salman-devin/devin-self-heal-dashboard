# Static host for the Devin Self-Heal dashboard.
# The dashboard is a single HTML file that reads the GitHub REST API from the
# browser, so the container serves files and nothing else. No secrets are
# baked in or required at runtime.
FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="devin-self-heal-dashboard" \
      org.opencontainers.image.description="Observability dashboard for the Devin self-healing maintenance automation" \
      org.opencontainers.image.source="https://github.com/salman-devin/devin-self-heal-dashboard"

COPY dashboard.html /usr/share/nginx/html/dashboard.html
COPY dashboard.html /usr/share/nginx/html/index.html

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost/index.html > /dev/null || exit 1

EXPOSE 80
