FROM nvidia/cudagl:11.2.1-devel-ubuntu18.04
RUN apt-get update 
RUN apt-get install -y cmake git libgtk2.0-dev \
    libgtk-3-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python-numpy \
    libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev wget gdb vim zip \
    libglu1-mesa-dev freeglut3-dev mesa-common-dev libgl1-mesa-dev libglew-dev libeigen3-dev

# Pangolin
RUN cd /opt \
    && git clone https://github.com/stevenlovegrove/Pangolin.git \
    && cd Pangolin && mkdir build && cd build && cmake .. \
    && make -j$(nproc) && make install

# OpenCV
ENV OPENCV 3.2.0
RUN cd /opt \
    && git clone https://github.com/opencv/opencv.git \
    && cd opencv && git checkout $OPENCV && cd .. \
    && git clone https://github.com/opencv/opencv_contrib.git \
    && cd opencv_contrib && git checkout $OPENCV && cd .. \
    && cd opencv && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE -DWITH_CUDA=OFF -DWITH_OPENGL=OFF -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules .. \
    && make -j$(nproc) && make install \
    && ldconfig
