FROM alpine
RUN apk update && apk add --no-cache aws-cli jq
COPY assume-role.sh /assume-role.sh
ENTRYPOINT ["/assume-role.sh"]
