-include .env
export

OPENEDX_RELEASE = 'open-release/ginkgo.master'
DEVSTACK_WORKSPACE ?= $(shell pwd)/..
CONTAINER_PREFIX=ed2go
DOCKER_TAG=no_upload

OS := $(shell uname)

export OPENEDX_RELEASE
export DEVSTACK_WORKSPACE
export CONTAINER_PREFIX
export DOCKER_TAG

build.base:
	docker build -t ${DOCKER_TAG}/xenial-base:ginkgo.master build/xenial-base

build.edxapp:
	docker build --build-arg container_prefix=${CONTAINER_PREFIX} -t ${DOCKER_TAG}/edxapp:${CONTAINER_PREFIX}-ginkgo.master build/edxapp

build.elasticsearch:
	docker build -t ${DOCKER_TAG}/elasticsearch:${CONTAINER_PREFIX}-ginkgo.master build/elasticsearch

build.forum:
	docker build --build-arg container_prefix=${CONTAINER_PREFIX} -t ${DOCKER_TAG}/forum:${CONTAINER_PREFIX}-ginkgo.master build/forum

clone:
	./clone-repos.sh

provision:
	./provision.sh

up:
	docker-compose -f docker-compose.yml -f docker-compose-host.yml up -d


test.ed2go:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver test_system -t lms/djangoapps/ed2go --settings=test_ed2go'

static:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_assets --settings devstack_docker'
	docker-compose exec studio bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_assets --settings devstack_docker'

static-lms:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_assets lms --settings=devstack_docker'

watch:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver watch_assets --td=/edx/app/edxapp/edx-platform/themes --t=ed2go-edx-theme --system=lms'

migrations:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && python manage.py lms makemigrations --settings=devstack_docker'

migrate:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && python manage.py lms migrate --settings=devstack_docker'

test:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver test_system -t lms/djangoapps/ed2go --settings=test_ed2go'


