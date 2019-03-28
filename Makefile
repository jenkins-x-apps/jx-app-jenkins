CHART_REPO := http://jenkins-x-chartmuseum:8080
CURRENT=$(pwd)
NAME := jx-app-jenkins
OS := $(shell uname)

CHARTMUSEUM_CREDS_USR := $(shell cat /builder/home/basic-auth-user.json)
CHARTMUSEUM_CREDS_PSW := $(shell cat /builder/home/basic-auth-pass.json)

init:
	helm init --client-only

setup: init
	helm repo add jenkinsxio http://chartmuseum.jenkins-x.io

build: clean setup
	rm -rf requirements.lock
	helm dependency build ${NAME}
	helm lint ${NAME}

install: clean build
	helm install ${NAME} --name ${NAME}

upgrade: clean build
	helm upgrade ${NAME} ${NAME}

delete:
	helm delete --purge ${NAME} ${NAME}

clean:
	rm -rf charts
	rm -rf ${NAME}*.tgz
	rm -rf requirements.lock

release: clean build
ifeq ($(OS),Darwin)
	sed -i "" -e "s/version:.*/version: $(VERSION)/" ${NAME}/Chart.yaml
else ifeq ($(OS),Linux)
	sed -i -e "s/version:.*/version: $(VERSION)/" ${NAME}/Chart.yaml
else
	echo "platform $(OS) not supported to tag with"
	exit -1
endif
	helm package ${NAME}
	curl --fail -u $(CHARTMUSEUM_CREDS_USR):$(CHARTMUSEUM_CREDS_PSW) --data-binary "@$(NAME)-$(VERSION).tgz" $(CHART_REPO)/api/charts
	rm -rf ${NAME}*.tgz%