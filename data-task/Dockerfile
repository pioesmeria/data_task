FROM mageai/mageai:latest

### Set up project-specific arguments
ARG PROJECT_NAME=data-task
ARG MAGE_CODE_PATH=/home/src
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

### Set working directory
WORKDIR ${MAGE_CODE_PATH}

### Copy project files
COPY ${PROJECT_NAME} ${PROJECT_NAME}

### Set the command to run on container startup
CMD ["/bin/sh", "-c", "/app/run_app.sh"]
