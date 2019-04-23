FROM no_upload/xenial-base:ginkgo.master
USER root
CMD ["/edx/app/supervisor/venvs/supervisor/bin/supervisord", "-n", "--configuration", "/edx/app/supervisor/supervisord.conf"]

RUN sudo rm -rf /edx/app/edx_ansible/edx_ansible
RUN git clone --depth 1 --branch open-release/ginkgo.master https://github.com/edx/configuration.git /edx/app/edx_ansible/edx_ansible
WORKDIR /edx/app/edx_ansible/edx_ansible/docker/plays

COPY ansible_overrides.yml /
COPY devstack.yml /
COPY devstack-ansible_overrides.yml /devstack/ansible_overrides.yml

ARG container_prefix
ARG OPENEDX_RELEASE=master
ENV OPENEDX_RELEASE=${OPENEDX_RELEASE}
RUN sudo /edx/app/edx_ansible/venvs/edx_ansible/bin/ansible-playbook edxapp.yml \
    -c local -i '127.0.0.1,' \
    -t 'install,assets,devstack' \
    --extra-vars=container_prefix=${container_prefix} \
    --extra-vars=edx_platform_version="develop" \
    --extra-vars="@/ansible_overrides.yml" \
    --extra-vars="@/devstack.yml" \
    --extra-vars="@/devstack/ansible_overrides.yml" \
	--extra-vars=edx_platform_repo="https://github.com/ExtensionEngine/ed2go-edx-platform.git" 

ENV ANG=en_US.UTF-8
ENV SKIP_WS_MIGRATIONS=1
ENV SELENIUM_PORT=4444
ENV SELENIUM_BROWSER=firefox
ENV PATH=/edx/app/edxapp/venvs/edxapp/bin:/edx/app/edxapp/edx-platform/bin:/edx/app/edxapp/edx-platform/node_modules/.bin:/edx/app/edxapp/nodeenvs/edxapp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV EDX_PLATFORM_SETTINGS=devstack_docker
ENV SELENIUM_HOST=ed2go.firefox
ENV CONFIG_ROOT=/edx/app/edxapp

COPY ./lms.env.json /edx/app/edxapp/lms.env.json
RUN sudo apt install nano

EXPOSE 18000 18010
