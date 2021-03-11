FROM golang:1.15.7-buster as builder

ENV APP_USER app
ARG GROUP_ID=10001
ARG USER_ID=10001

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor
ENV CGO_ENABLED=0

RUN go get -u github.com/beego/bee
RUN groupadd --gid $GROUP_ID app && useradd -m -l --uid $USER_ID --gid $GROUP_ID $APP_USER

FROM scratch

ENV APP_USER app
ENV APP_HOME /go/src/mathapp

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder --chown=$APP_USER /home/$APP_USER /home/$APP_USER
COPY --from=builder /go/bin/bee /go/bin/bee

USER $APP_USER
WORKDIR $APP_HOME
EXPOSE 8010
CMD ["/go/bin/bee", "run"]
