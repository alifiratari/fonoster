#!/bin/bash

function install-swarm() {
  info "Checking if the application is already installed..."
  check_if_installed

  [ -z "$HTTP_PORT" ] && HTTP_PORT=51051
  [ -z "$HTTPS_PORT" ] && HTTPS_PORT=443


  
  if [ "$ENABLE_EXTERNAL_TRAEFIK" = "true" ]; then
    info "Passing check the required ports are available... You are using external traefik instance!"
  else
    info "Checking if the required ports are available..."
    check_ports "$HTTP_PORT" "$HTTPS_PORT"  
  fi

  # Get the latest version of the application from the GitHub repository
  get_latest_version

  [ -z "$FONOSTER_VERSION" ] && FONOSTER_VERSION=$FONOSTER_LATEST_VERSION
  check_version "$FONOSTER_VERSION"

  info "Installing Fonoster... 📦 "
  execute "cd /work"

  info "Generating private key... 🔑 "
  {
    openssl rand -hex 16
  } >config/private_key

  info "Configuring docker host and sets environment variables... 💻 "
  [ -z "$DOCKER_HOST_IP" ] && DOCKER_HOST_IP=$(netdiscover -field publicv4)

  {
    echo ""
    echo "DOCKER_HOST_ADDRESS=$DOCKER_HOST_IP"
    echo "RTPE_HOST=$DOCKER_HOST_IP"
  } >>operator/.env

  info "Configuring domain... 🌐 "
  [ -z "$DOMAIN" ] && DOMAIN=$DOCKER_HOST_IP

  if [ "$ENABLE_TLS" = "true" ]; then
    [ -z "$LETSENCRYPT_EMAIL" ] && LETSENCRYPT_EMAIL="admin@$DOMAIN"

    {
      echo "LETSENCRYPT_DOMAIN=$DOMAIN"
      echo "LETSENCRYPT_EMAIL=$LETSENCRYPT_EMAIL"
      echo "PUBLIC_URL=https://$DOMAIN"
    } >>operator/.env

  else
    echo "PUBLIC_URL=http://$DOMAIN:$HTTP_PORT" >>operator/.env
  fi

  [ "$GLOBAL_SIP_DOMAIN" ] && {
    echo "GLOBAL_SIP_DOMAIN=$GLOBAL_SIP_DOMAIN" >>operator/.env
  }

  info "Generating service secrets... 🔑 "
  execute "cd operator" "./gen-secrets.sh"

  set_env

  info "Copying the application to the output directory... 📁 "
  execute "cp -a /work/* /out"

  info "Creating swarm service and user credentials... 🔑 "
  #execute "docker stack deploy -c fonoster-stack.yml fonoster --with-registry-auth"
  execute "env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy  -c fonoster-stack.yml fonoster --with-registry-auth"

  info "Removing initiaization resources... 📦 "
  execute "docker ps --filter status=exited -q | xargs docker rm >/dev/null"

  # info "Please wait, the next command will take a few minutes... 🕐 "
  # if [ "$ENABLE_TLS" = "true" ]; then
  #   execute "bash ./basic-network.sh start"
  # else
  #   execute "bash ./basic-network.sh start-unsecure"
  # fi

  info "Finished 📦 "
 
}
