FROM nginx:alpine

# Copy the HTML file to nginx web directory
COPY index.html /usr/share/nginx/html/

# Create a template for environment variable substitution
COPY index.html /usr/share/nginx/html/index.html.template

# Create a script to substitute environment variables
RUN echo '#!/bin/sh' > /docker-entrypoint.d/40-envsubst.sh && \
    echo 'if [ -n "$GEMINI_API_KEY" ]; then' >> /docker-entrypoint.d/40-envsubst.sh && \
    echo '  sed "s|</head>|<script>const GEMINI_API_KEY = \"$GEMINI_API_KEY\";</script></head>|" /usr/share/nginx/html/index.html.template > /usr/share/nginx/html/index.html' >> /docker-entrypoint.d/40-envsubst.sh && \
    echo 'else' >> /docker-entrypoint.d/40-envsubst.sh && \
    echo '  cp /usr/share/nginx/html/index.html.template /usr/share/nginx/html/index.html' >> /docker-entrypoint.d/40-envsubst.sh && \
    echo 'fi' >> /docker-entrypoint.d/40-envsubst.sh && \
    chmod +x /docker-entrypoint.d/40-envsubst.sh

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]