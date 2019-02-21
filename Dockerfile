FROM fedora:29

RUN dnf update -y && \
    dnf install -y mingw64-gcc \
                mingw64-pixman \
                mingw64-glib2 \
                git \
                make \
                python\
                autoconf \
                xorg-x11-util-macros

COPY angle/include/ /usr/x86_64-w64-mingw32/sys-root/mingw/include/
COPY angle/egl.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/
COPY angle/glesv2.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/

RUN git clone https://github.com/anholt/libepoxy && \
    cd libepoxy && \
    ./autogen.sh; \
    mingw64-configure --enable-egl && \
    make -j8 && \
    make install

RUN git clone https://github.com/matthias-prangl/SDL-mirror/ && \
    cd SDL-mirror && \ 
    mingw64-configure && \
    make -j8 && \
    make install

RUN git clone https://github.com/matthias-prangl/virglrenderer/ && \
    cd virglrenderer && \
    ./autogen.sh; \
    mingw64-configure --disable-egl && \
    make -j8 && \
    make install


RUN git clone https://github.com/matthias-prangl/qemu/ && \
    cd qemu && \
    ./configure --target-list=x86_64-softmmu \
                --prefix=/qemu_win \
                --cross-prefix=x86_64-w64-mingw32- \
                --enable-hax \
                --enable-virglrenderer \
                --enable-opengl \
                --disable-stack-protector \
                --enable-sdl && \
    make -j8 && \
    make install
