#!/bin/bash
meteor build --server https://cn.steedos.com/workflow --directory /srv/workflow
cd /srv/workflow/bundle/programs/server
npm install
cd ../../../
pm2 restart workflow.0