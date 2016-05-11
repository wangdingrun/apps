export MONGO_URL=mongodb://192.168.0.23/steedos
export MONGO_OPLOG_URL=mongodb://192.168.0.23:27017/local
export MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
export ROOT_URL=http://127.0.0.1:3000/workflow/
meteor run --settings settings.json
