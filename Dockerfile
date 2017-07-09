# To build: docker build -t cjs/school_backend .
# To run:   docker run -p 8080:8080 --name school -d cjs/school_backend
FROM vapor/vapor:latest

MAINTAINER carl-johan.svedin@infomaker.se

ADD . /opt/Vapor/SchoolBackend

WORKDIR /opt/Vapor/SchoolBackend

EXPOSE 8080
CMD ["vapor", "run"]
#CMD ["/bin/bash"]
