## template: jinja
#cloud-config
# yamllint disable rule:document-start rule:line-length
write_files:
  - path: /etc/systemd/system/webapp.service
    permissions: 0644
    owner: root
    content: |
      [Unit]
      Description=Webapp in NGINX
      Wants=gcr-online.target
      After=gcr-online.target

      [Service]
      ExecStart=/usr/bin/docker run --rm --name webapp -p 80:80 -v /var/lib/webapp:/usr/share/nginx/html:ro nginx:alpine
      ExecStop=/usr/bin/docker stop webapp
      ExecStopPost=/usr/bin/docker rm webapp
  - path: /var/lib/webapp/index.html
    permissions: 0644
    owner: root
    content: |
      <html>
        <head>
          <title>Webapp</title>
        </head>
        <body>
          <h1>This webapp is running on {{ v1.local_hostname }}.</h1>
        </body>
      </html>
  - path: /etc/systemd/system/metrics.service
    permissions: 0644
    owner: root
    content: |
      [Unit]
      Description=Synthetic Metrics
      Wants=gcr-online.target
      After=gcr-online.target

      [Service]
      ExecStart=/usr/bin/docker run --rm --name gce-metric memes/gce-metric:${gce_metric_ver} ${shape} -verbose -round -floor ${floor} -ceiling ${ceiling} -period ${period} -sample ${sample} ${type}
      ExecStop=/usr/bin/docker stop gce-metric
      ExecStopPost=/usr/bin/docker rm gce-metric

packages:
  - docker.io

runcmd:
  - systemctl daemon-reload
  - systemctl start webapp.service
  - systemctl start metrics.service
