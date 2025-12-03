# pulls the docker logstash image
docker pull docker.elastic.co/logstash/logstash:8.17.0

# runs a docker elastic container
docker run --rm -d -p 5044:5044/tcp -p 9600:9600/tcp --name logstash docker.elastic.co/logstash/logstash:8.17.0 

# directs syslog contents to the logstash container created above
sudo mkdir -p /etc/syslog-ng
sudo tee /etc/syslog-ng/syslog-ng.conf > /dev/null <<EOL
@version: 3.5
source s_local {
    system();
    internal();
};

destination d_logstash {
    tcp("127.0.0.1" port(5044));
};

log {
    source(s_local);
    destination(d_logstash);
};
EOL

# restart syslog-ng to apply the new configuration
sudo brew services restart syslog-ng