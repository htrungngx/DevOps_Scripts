sudo mkdir /opt/promtail
PROMTAIL_VERSION="2.8.2"
sudo wget -qO /opt/promtail/promtail.gz "https://github.com/grafana/loki/releases/download/v${PROMTAIL_VERSION}/promtail-linux-amd64.zip"
sudo gunzip /opt/promtail/promtail.gz
sudo chmod a+x /opt/promtail/promtail
sudo ln -s /opt/promtail/ /usr/local/bin/promtail
sudo cp promtail-config.yaml /opt/promtail/promtail-local-config.yaml
sudo cp promtail.service /etc/systemd/system/promtail.service
sudo service promtail start
sudo service promtail status
sudo systemctl enable promtail
