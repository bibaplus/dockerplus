FROM srv-nexus-3.bcom.com:5000/pbc/base_image_ubi8:java8 as builder
ADD app.war /opt/
USER root
RUN cd /opt/ && \
yes | unzip -qq app.war -d app

FROM srv-nexus-3.bcom.com:5000/common/redos/7.3.1/tomcat/9.0.65:lbjdk11
COPY --from=builder /opt/app/ /opt/tomcat/webapps/app/
USER root

CMD ${CATALINA_BASE}/bin/startup.sh run 2>&1 | tee ${CATALINA_BASE}/logs/catalina.out | tail -F /opt/logs/catalina.out
