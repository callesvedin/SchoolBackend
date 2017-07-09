FROM vapor/vapor:latest

MAINTAINER carl-johan.svedin@infomaker.se

ADD . /opt/Vapor/SchoolBackend

WORKDIR /opt/Vapor/SchoolBackend

EXPOSE 8080
CMD ["vapor", "run"]
#CMD ["/bin/bash"]
