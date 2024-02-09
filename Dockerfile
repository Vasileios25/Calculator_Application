# Use the official Python base image
FROM ubuntu:20.04
# Update the pachage lists
RUN apt-get update && \
    apt-get install -y python3-pip postgresql-client && \
    rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
#RUN pip install -r ./requirements.txt
#RUN pip install psycopg2-binary


#COPY ../Calculator/database/entrypoint.sh /entrypoint.sh
#COPY . /Calculator.py
# Set the working directory in the container
WORKDIR  /Test
COPY requirements.txt Calculator.py /Test/
COPY ./Calculator.py /Calculator.py
COPY init_db.sql /docker-entrypoint-initdb.d/
#RUN chmod -R 765 /entrypoint.sh


#install the Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Run the Python application
#ENTRYPOINT python3 /Calculator.py
ENTRYPOINT ["python3", "/Calculator.py"]
CMD ["/bin/bash"]