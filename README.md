# Dependencies

To run qemu with virgl on windows additional ANGLE dlls  are required:    

- libEGL.dll
- libGLESv2.dll
- d3dcompiler_47.dll

# Run qemu with virgl (GLES)

`qemu-system-x86_64-softmmu /path/to/image -vga virtio -display sdl,gl=es`