if ($args.count -lt 3) {
    write-host "Usage: build_qemu.ps1 IMAGE_TAG QEMU_SOURCE_PATH VIRGL_SOURCE_PATH"
    exit 1
}
$image_tag = $args[0]
$qemu_path = (convert-path $args[1])
$virgl_path = (convert-path $args[2])
$install_path = (convert-path .\..\)

if (!(test-path -path ${install_path}\qemu_win\)) {
    mkdir ${install_path}\qemu_win\
}
$install_path = (convert-path .\..\qemu_win\)

docker run  -v ${virgl_path}:/virglrenderer/ `
    -v ${qemu_path}:/qemu/ `
    -v ${install_path}:/qemu_win/ `
    ${image_tag} /bin/bash -c `
        "export NOCONFIGURE=1;
        cd /virglrenderer; ./autogen.sh; \
        mingw64-configure --disable-egl && \
        make -j4 && make install && \
        cd /qemu; \
        ./configure --target-list=x86_64-softmmu \
        --prefix=/qemu_win \
        --cross-prefix=x86_64-w64-mingw32- \
        --enable-hax \
        --enable-virglrenderer \
        --enable-opengl \
        --disable-stack-protector \
        --enable-sdl && make -j4 && make install &&
        cp /virglrenderer/src/.libs/libvirglrenderer-0.dll /qemu_win"