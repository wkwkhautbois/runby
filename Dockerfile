FROM ruby:2.6.6-slim
RUN apt-get update && \
    apt-get install -y nodejs npm libmariadb-dev && \
    npm i -g yarn


# Install SSH server
# https://docs.microsoft.com/en-us/azure/app-service/containers/tutorial-custom-docker-image#enable-ssh-connections
# ENV SSH_PASSWD "root:Docker!"
# RUN apt-get update \
#         && apt-get install -y --no-install-recommends dialog \
#         && apt-get update \
#   && apt-get install -y --no-install-recommends openssh-server \
#   && echo "$SSH_PASSWD" | chpasswd
# COPY sshd_config /etc/ssh/

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY yarn.lock /myapp/yarn.lock

RUN bundle install --without test
RUN yarn install


COPY DigiCertGlobalRootCA.crt.pem /myapp/DigiCertGlobalRootCA.crt.pem
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000 2222

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]