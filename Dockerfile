FROM alpine
RUN apk update && apk add --no-cache aws-cli jq
COPY assume-role.sh /assume-role.sh
COPY env-var-names.json /env-var-names.json 
ENTRYPOINT ["/assume-role.sh"]
