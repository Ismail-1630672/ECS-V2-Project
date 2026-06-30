FROM golang:1.23-alpine AS buildtime

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o ./dashboard


FROM gcr.io/distroless/base-debian12:nonroot

WORKDIR /app 

COPY --from=buildtime /app/dashboard ./dashboard 

EXPOSE 8081

CMD ["/app/dashboard"]