#!/bin/bash

set -e
set -x

cat >/root/.boto <<EOF
[Boto]
https_validate_certificates = True

[GSUtil]
content_language = en
default_api_version = 2
default_project_id = $GCS_PROJECT_ID
parallel_process_count=1
parallel_thread_count=1
parallel_composite_upload_threshold=0
sliced_object_download_threshold=0
EOF

chmod 644 /root/.boto

DESTFILE="/inputs/$(basename $CMS_INPUT_FILES)"
if [ "$DPATH" != "/mnt/disks/ssd0" ] && [ "$DPATH" != "/dev/shm" ]; then
  echo "Launched in test mode, won't write to disk"
  trickle -s -d $DOWNLOAD_MAX_KB -u $UPLOAD_MAX_KB gsutil cp $(echo $CMS_INPUT_FILES | sed 's#gs/#gs://#') - | cat > /dev/null
else
  trickle -s -d $DOWNLOAD_MAX_KB -u $UPLOAD_MAX_KB gsutil cp $(echo $CMS_INPUT_FILES | sed 's#gs/#gs://#') - | cat > $DESTFILE
fi
