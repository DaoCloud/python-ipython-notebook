 FROM python:2.7
 MAINTAINER Captain Dao <support@daocloud.io>
 RUN mkdir -p /app
 WORKDIR /app
 ADD requirements.txt requirements.txt
 RUN pip install -r requirements.txt
 EXPOSE 8888
 COPY docker-entrypoint.sh /usr/local/bin/
 ENTRYPOINT ["docker-entrypoint.sh"]
 CMD ["sh"]
