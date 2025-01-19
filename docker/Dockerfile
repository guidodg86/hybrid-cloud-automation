
# INSTRUCTIONS

#     To build:
#     docker build  -t guido/terraform . 
#     To build with debug:
#     docker build . --progress=plain --no-cache
#     To run docker container with terraform (from powershell on folder of terraform files):
#     docker run  -it -v $(pwd):/terraform-data/  guido/terraform 
#     To clean cache of builder:
#     docker builder prune


FROM ubuntu:rolling
WORKDIR /usr/local/terraform


RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    iputils-ping \
    net-tools \
    curl \
    telnet \
    openssh-client \
  && rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://releases.hashicorp.com/terraform/1.9.7/terraform_1.9.7_linux_amd64.zip \
  && unzip terraform_1.9.7_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_1.9.7_linux_amd64.zip


CMD ["bash"]