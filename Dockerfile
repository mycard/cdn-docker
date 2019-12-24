FROM node:buster-slim

# pm2
RUN npm install -g pm2

# apt
RUN apt update && \
	env DEBIAN_FRONTEND=noninteractive apt -y install wget gnupg  ca-certificates software-properties-common apt-transport-https && \
	wget -O - https://openresty.org/package/pubkey.gpg | apt-key add - && \
	add-apt-repository -y "deb https://nginx.org/packages/mainline/debian/ $(lsb_release -sc) nginx" && \
	add-apt-repository -y "deb-src https://nginx.org/packages/mainline/debian/ $(lsb_release -sc) nginx" && \
	apt update && \
	env DEBIAN_FRONTEND=noninteractive apt -y install nginx rsync logrotate openssh-server python locales cron && \
	rm -rf /var/lib/apt/lists/*

# configures
RUN echo '0 4 * * * /usr/sbin/logrotate /etc/logrotate.conf' > /etc/cron.d/logrotate && \
	crontab /etc/cron.d/logrotate && \
	mkdir -p /var/run/sshd && \
	mkdir /root/.ssh && \
	echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
	echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtRix6NrCSXMNpL9WuD6DA198aGirvb8cYIcx5fS98/EWqA8n8yjBEjfLkWZviSh8J6hDw5x4rlZWa777eP+qFfwZO5MjQp/n3cgpZgnbJFRUROuNEyaGQvv09uO05cgRKemVDysqte6xjH6YOts/+oX6dC/JK+Cwi7K0kUETQ2WLLTghyQfLkwKoXkP30v/j18yfyswyWsM1E70stmezMRYswsAeOP6j5/dZiSY9vPCPHJ0w3cGhV+YZcWVE3687cQyf++Iv4AGBzRWlGStGHfb3UB8fkeIClChkQDjjzrxfbrmeS3kC5w6hkbZFsreM8ZvWhDvB1eBxjU9KKbV0iQ== zh99998@gmail.com' >> /root/.ssh/authorized_keys && \
	echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    locale-gen && \
    dpkg-reconfigure -f noninteractive locales tzdata && \
    /usr/sbin/update-locale LANG=zh_CN.UTF-8

ENV LANG=zh_CN.UTF-8
COPY logrotate.conf /etc/logrotate.conf
COPY ./pm2.json /etc/pm2.json
EXPOSE 22 80 443
CMD ["pm2-docker", "/etc/pm2.json"]
