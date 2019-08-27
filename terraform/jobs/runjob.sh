#!/bin/bash

set -e
set -x

if [ "$DPATH" != "/mnt/disks/ssd0" ] && [ "$DPATH" != "/dev/shm" ]; then
  echo "Launched in test mode, won't do compute"
  sleep 60
  exit
fi

echo "Running locally over: ${CMS_INPUT_FILES}"

export CMS_INPUT_FILES="file:///inputs/$(basename $CMS_INPUT_FILES)"
echo "Actual files ${CMS_INPUT_FILES}"
time /opt/cms/entrypoint.sh cmsRun ${CMS_CONFIG}

mkdir -p /tmp/outputs
CMS_OUTPUT_JSON_FILE="/tmp/outputs/$(basename ${CMS_INPUT_FILES})"
/opt/cms/entrypoint.sh python /dump_json_pyroot.py ${CMS_OUTPUT_FILE} ${CMS_DATASET_NAME} ${CMS_OUTPUT_JSON_FILE}
cat ${CMS_OUTPUT_JSON_FILE}
echo ${CMS_LUMINOSITY_DATA}
python /publish_single.py ${CMS_OUTPUT_JSON_FILE}
rm -f "/mnt/inputs/$(basename $CMS_INPUT_FILES)" || true
