##
## Dependencies
##
FROM fonoster/base AS deps
WORKDIR /work

LABEL maintainer="Pedro Sanders <psanders@fonoster.com>"

# Install dependencies and set permissions
RUN apk add --no-cache --update git curl docker docker-compose openssl bash \
  && curl -qL -o /usr/bin/netdiscover https://github.com/CyCoreSystems/netdiscover/releases/download/v1.2.5/netdiscover.linux.amd64 \
  && chmod +x /usr/bin/netdiscover \
  && curl -qL -o /usr/bin/semver https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver \
  && chmod +x /usr/bin/semver
##
## Stage
##
FROM deps AS stage
WORKDIR /work

# Copy relevant files
COPY . /work/fonoster

# Copy configuration files
RUN mkdir -p docker operator config \
  && touch config/config config/user_credentials \
  && cp -r fonoster/docker . \
  && cp -a fonoster/operator/compose/* operator \
  && cp -a fonoster/operator/swarm/* operator \
  && mv operator/env_example operator/.env \
  && cp fonoster/etc/rbac.json config \
  && cp fonoster/etc/limiters.json config \
  && cp fonoster/etc/log4j2.yml config \
  && cp fonoster/etc/bootstrap.yml config \
  && cp fonoster/etc/redis.conf config \
  && cp fonoster/etc/fluent.conf config \
  && cp fonoster/etc/service_envs.json config \
  && cp fonoster/etc/install.sh . \
  && cp fonoster/etc/update.sh . \
  && cp fonoster/etc/stop.sh . \
  && cp fonoster/etc/install-swarm.sh . \
  && cp fonoster/etc/stop-swarm.sh . \
  && rm -rf fonoster

##
## Serve
##
FROM stage AS serve
WORKDIR /work

COPY --from=stage /work/install.sh /work/update.sh /work/stop.sh ./
COPY --from=stage /work/docker /work/docker
COPY --from=stage /work/install-swarm.sh /work/stop-swarm.sh ./

RUN find . -type f -iname "*.sh" -exec chmod +x {} + \
  && mv /work/install.sh /install.sh \
  && mv /work/update.sh /update.sh \
  && mv /work/stop.sh /stop.sh \
  && mv /work/install-swarm.sh /install-swarm.sh \
  && mv /work/stop-swarm.sh /stop-swarm.sh \
  && mv /work/docker /docker \
  && chown -R fonoster:fonoster /work

ENTRYPOINT [ "/install.sh" ]
