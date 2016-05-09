export MONGO_URL=mongodb://127.0.0.1/steedos
export MONGO_OPLOG_URL=mongodb://localhost:27017/local
export MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
export ROOT_URL=http://127.0.0.1:3000/workflow/
meteor run --settings settings.json
