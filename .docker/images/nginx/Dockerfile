FROM nginx:1.16
ARG APP_HOST
ARG NGINX_ENABLE_HTTPS

COPY ./ssl/ /etc/ssl/certs/
COPY ./ssl/ /etc/ssl/private/

COPY ./sites/site.conf.template /etc/nginx/sites-available/site.conf.template
COPY ./sites/ssl-site.conf.template /etc/nginx/sites-available/ssl-site.conf.template
RUN envsubst '${APP_HOST}' < /etc/nginx/sites-available/site.conf.template > /etc/nginx/sites-available/site.conf
RUN envsubst '${APP_HOST}' < /etc/nginx/sites-available/ssl-site.conf.template > /etc/nginx/sites-available/ssl-site.conf

RUN rm -f /etc/nginx/sites-available/site.conf.template && rm -f /etc/nginx/sites-available/ssl-site.conf.template

RUN if [ "${NGINX_ENABLE_HTTPS}" = "1" ] ; then \
    rm -f /etc/nginx/sites-available/site.conf; \
else \
    rm -f /etc/nginx/sites-available/ssl-site.conf; \
fi
