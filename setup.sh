# Docker version
# repos
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# dependencies
sudo dnf install -y --nobest docker-ce
sudo dnf install -y nano git certbot python3-certbot-nginx

# setup
sudo mkfs.ext4 /dev/sdb
sudo mkdir /storage
sudo mount /dev/sdb /storage
sudo mkdir /storage/jenkins_home
sudo chown 1000 /storage/jenkins_home
sudo mkdir /storage/nginx
sudo chown 101 /storage/nginx/conf
sudo setsebool -P httpd_can_network_connect 1
sudo sysctl net.ipv4.ip_forward=1
sudo systemctl enable docker
sudo systemctl start docker
sudo docker pull nginx
sudo docker run --name nginx -v /storage/nginx/conf:/etc/nginx/conf -p 80:80 -d nginx
sudo certbot --nginx --nginx-server-root /build
sudo docker pull jenkins/jenkins:lts
sudo docker container run --name jenkins -d -v /client-storage/jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 --net=host jenkins/jenkins:lts
