FROM nginx:stable-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system symfony
RUN adduser -G symfony --system -D -s /bin/sh -u ${UID} symfony
RUN sed -i "s/user  nginx/user symfony/g" /etc/nginx/nginx.conf

ADD ./nginx/default.conf /etc/nginx/conf.d/

RUN mkdir -p /var/www/html

WORKDIR /app

# Install Vue CLI globally
RUN npm install -g @vue/cli

# Copy package.json and yarn.lock files
#COPY ./src/vue/package.json ./src/vue/yarn.lock ./

# Install project dependencies
RUN yarn install

# Copy project files
#COPY ./src/vue ./

# Expose the Vue development server port
EXPOSE 8080

# Start the Vue development server
CMD ["npm", "run", "serve"]