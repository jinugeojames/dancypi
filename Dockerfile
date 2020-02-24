# base-image for python on any machine using a template variable,
# see more about dockerfile templates here: https://www.balena.io/docs/learn/develop/dockerfile/
FROM balenalib/%%BALENA_MACHINE_NAME%%-python:3-stretch-run

# use `install_packages` if you need to install dependencies,
# for instance if you need git, just uncomment the line below.
# RUN install_packages git

# Set our working directory
WORKDIR /usr/src/app



# pip install python deps on the resin.io build server
RUN pip install numpy
RUN pip install scipy
RUN pip install pyqtgraph
RUN pip install pyaudio

# This will copy all files in our root to the working  directory in the container
COPY . ./



RUN cd rpi_ws281x
RUN scons
RUN cd python
RUN sudo python setup.py install

# Enable udevd so that plugged dynamic hardware devices show up in our container.
ENV UDEV=1

# main.py will run when container starts up on the device
CMD ["python","-u","python/vizualization.py spectrum"]