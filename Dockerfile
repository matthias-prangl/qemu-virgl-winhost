FROM fedora:latest

RUN dnf update -y && \
    dnf install -y mingw64-gcc \
                mingw64-glib2 \
                mingw64-pixman \
                git \
                make \
                flex \
                bison \
                python \
                autoconf \
                xorg-x11-util-macros

COPY angle/include/ /usr/x86_64-w64-mingw32/sys-root/mingw/include/
COPY angle/egl.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/
COPY angle/glesv2.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/
COPY WinHv*.h /usr/x86_64-w64-mingw32/sys-root/mingw/include/

RUN git clone https://github.com/anholt/libepoxy && \
    export NOCONFIGURE=1; \
    cd libepoxy && \
    ./autogen.sh; \
    mingw64-configure --enable-egl && \
    make -j2 && \
    make install

RUN git clone https://github.com/matthias-prangl/SDL-mirror/ && \
    cd SDL-mirror && \ 
    mingw64-configure && \
    make -j2 && \
    make install

RUN git clone https://github.com/matthias-prangl/virglrenderer.git && \
    cd virglrenderer && \
    export NOCONFIGURE=1 && \
    ./autogen.sh && \
    mingw64-configure --disable-egl && \
    make -j2 && \
    make install

RUN git clone https://github.com/matthias-prangl/qemu.git && \
    cd qemu && \
    export NOCONFIGURE=1 && \
    ./configure --target-list=x86_64-softmmu \
    --prefix=/qemu_win \
    --cross-prefix=x86_64-w64-mingw32- \
    --enable-hax \
    --enable-whpx \
    --enable-virglrenderer \
    --enable-opengl \
    --enable-debug \
    --disable-stack-protector \
    --enable-sdl && \
    make -j2 && make install