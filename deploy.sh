set -e

JQ="jq --raw-output --exit-status"

IMAGE="ecs-node-webserver-test"

SERVICE="ecs-node-webserver-service"

TASK_DEF="ecs-node-webserver-tasks"

REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"

REPO="ecs-node-webserver-test"

BUILD="$CIRCLE_SHA1"

UPDATED_IMAGE="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE:$BUILD"

CLUSTER="ecs-webapp-cluster"

function push_to_registry () {
  # login to aws, altough circle CI creds may do this just fine
  eval $(aws ecr get-login --region $AWS_DEFAULT_REGION)

  # this is already built due to the dependencies circle ci yaml
  docker push $UPDATED_IMAGE
}

function update_webserver () {

  # update template with newest image build
  cat ./task-definition.json | $JQ ".containerDefinitions[0].image=$UPDATED_IMAGE" > ./updated_task.json
  
  # register the updated task with the new image
  aws ecs register-task-definition \
    --cli-input-json file://updated_task.json

  # update the service to use the new task
  aws ecs update-service --cluster $CLUSTER --service $SERVICE \
    --task-definition $TASK_DEF

  # remove temp file
  rm -rf ./updated_task.json
}

push_to_registry
update_webserver