FROM centos:centos7.6.1810

#Variable for ops manager version
ENV opsmgsver=4.0.12.50517.20190605T1533Z-1

#for quicker development download file once locally then use with below line
#COPY mongodb-mms-4.0.12.50517.20190605T1533Z-1.x86_64.rpm ~/downloads/

#Install dependencies, wget for doing --no-check-certificate behind firewall if curl -kO does not work
RUN yum makecache fast \
    && yum install -y wget openssl net-tools \
    && yum clean all

#Get and install Ops Manager, remove rpm to make image smaller
RUN mkdir -p /downloads/ 

WORKDIR /downloads/

RUN curl -O https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-${opsmgsver}.x86_64.rpm \
    && yum localinstall -y mongodb-mms-${opsmgsver}.x86_64.rpm \
    && yum clean all \
    && rm -f mongodb-mms-${opsmgsver}.x86_64.rpm 

#Expose Ports
EXPOSE 8080/tcp 8443/tcp

#Set required permissions. Setting recursive permissions on /opt/mongodb will lead to image size of over 2.3 GB
RUN chown -R mongodb-mms:mongodb-mms /etc/mongodb-mms/ \
    && chmod u+s /etc/mongodb-mms/ \
    && chmod g+s /etc/mongodb-mms/ \
    && mkdir -p /var/log/mongodb/ \
    && chown -R mongodb-mms:mongodb-mms /var/log/mongodb/ \
    && chmod u+s /var/log/mongodb/ \
    && chmod g+s /var/log/mongodb/ \
    && chown -R mongodb-mms:mongodb-mms /opt/mongodb/mms/mongodb-releases/ \
    && chmod u+s /opt/mongodb/mms/mongodb-releases/ \
    && chmod g+s /opt/mongodb/mms/mongodb-releases/ \
    && chown -R mongodb-mms:mongodb-mms /opt/mongodb/mms/agent/ \
    && chmod g+s /opt/mongodb/mms/agent/ \
    && chmod g+s /opt/mongodb/mms/agent/
    
COPY docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR /
RUN chmod +x /docker-entrypoint.sh

USER mongodb-mms

RUN ls -liah /opt/mongodb \
    && ls -liah /opt/mongodb/mms \
    && ls -liah /opt/mongodb/mms/mongodb-releases \
    && id

#Start ops manager
ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["mongodb-mms"]