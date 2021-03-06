FROM golang:1.4
ENV PORT 80
EXPOSE 80
RUN apt-get update && apt-get install -yqq aspell aspell-en libaspell-dev tesseract-ocr tesseract-ocr-eng imagemagick optipng exiftool libjpeg-progs
RUN wget https://github.com/johnlinp/meme-ocr/raw/master/tessdata/joh.traineddata -O /usr/share/tesseract-ocr/tessdata/meme.traineddata
RUN mkdir -p /etc/mandible /tmp/imagestore
ADD docker/conf.json /etc/mandible/conf.json
ENV MANDIBLE_CONF /etc/mandible/conf.json
ADD . /go/src/github.com/Imgur/mandible
WORKDIR /go/src/github.com/Imgur/mandible
RUN go get golang.org/x/tools/cmd/vet
RUN go get -v ./...
RUN go install -v ./...
RUN go test -v ./...
RUN go vet ./...
CMD ["mandible"]
