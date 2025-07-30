# 1- Download and install python 3
FROM python:3.13.2-slim-bullseye
# Setup linux os packages

# 2- Create virtual environment
# 3- Install dependencies
# 4- FastAPI Hello

# Create virtual environment
RUN python -m venv /opt/venv

# Set the virtual Environment as the current working directory
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN pip install --upgrade pip

# Set python related environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install os dependencies for our mini vm
RUN apt-get update && apt-get install -y \
    # for postgress
    libpq-dev \
    # for pillow
    libjpeg-dev \
    # for cairoSVG
    libcairo2 \
    # other
    gcc

# Create mini vm's code directory
RUN mkdir -p /code

# Set the working directory
WORKDIR /code

# Copy required files into the container
COPY requirements.txt /temp/requirements.txt
# copy the project code into the container's working directory'
COPY ./src /code


# Install dependencies
RUN pip install -r /temp/requirements.txt



# make the bash script executable
COPY ./boot/docker_run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

# Clean up apt cache to reduce image size
RUN apt-get remove --purge -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Run the FastAPI project via the runtime script
# when the container starts
CMD ["/opt/run.sh"]