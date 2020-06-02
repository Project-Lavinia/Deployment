# parameters
CLIENT_IP=$1
CLIENT_DEV_IP=$2
API_IP=$3
API_DEV_IP=$4
export CLIENT_IP CLIENT_DEV_IP API_IP API_DEV_IP

# repos
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# dependencies
sudo dnf install -y --nobest docker-ce
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo dnf install -y nano

# setup
sudo mkfs.ext4 /dev/sdb
sudo mkdir /storage
sudo mount /dev/sdb /storage
sudo mkdir /storage/jenkins_home
sudo chown 1000 /storage/jenkins_home
sudo mkdir -p /storage/nginx/conf.d
sudo wget -O /storage/nginx/conf.d/.conf https://raw.githubusercontent.com/Project-Lavinia/Deployment/master/nginx.conf
envsubst < /storage/nginx/conf.d/.conf | sudo tee /storage/nginx/conf/nginx.conf
sudo chown 101 /storage/nginx/conf.d
sudo setsebool -P httpd_can_network_connect 1
sudo sysctl net.ipv4.ip_forward=1
sudo systemctl enable docker
sudo systemctl start docker
sudo wget https://raw.githubusercontent.com/Project-Lavinia/Deployment/master/docker-compose.yml
sudo /usr/local/bin/docker-compose up -d
