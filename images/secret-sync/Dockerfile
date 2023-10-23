FROM registry.access.redhat.com/ubi8/python-311:1-25.1696515654

# VULN_SCAN_TIME=2023-07-31_05:12:49

# Ensures written logs are made available directly
ENV PYTHONUNBUFFERED=1

RUN pip install --no-cache --no-cache-dir kubernetes==28.1.*
COPY acme-secret-sync.py /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/acme-secret-sync.py" ]
