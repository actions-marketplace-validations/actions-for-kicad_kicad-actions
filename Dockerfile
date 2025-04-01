ARG KICAD_VERSION=9.0
FROM kicad/kicad:${KICAD_VERSION}

USER root

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
