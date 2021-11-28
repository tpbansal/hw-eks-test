FROM httpd:2.4-alpine

# Create user and set ownership and permissions as required
RUN adduser -D myuser 

COPY ./index.html /usr/local/apache2/htdocs/