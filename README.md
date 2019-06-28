# Dependencies

To to build qemu with whpx option the following headers from the Windows SDK are required:

- WinHvEmulation.h
- WinHvPlatform.h
- WinHvPlatformDefs.h

These Headers are probably at `C:\Program Files (x86)\Windows Kits\10\Include\<your_windows_version>\um` and should be copied to the folder with Dockerfile.

To run qemu with virgl on windows additional ANGLE dlls are required:    

- libEGL.dll
- libGLESv2.dll
- d3dcompiler_47.dll

# Build QEMU with the dockerfile

Run `docker build -t <tag> .`.

Copy from container to host: `docker cp <container_id>:/qemu_win <dest_folder>`

# Run qemu with virgl (GLES)

`qemu-system-x86_64-softmmu /path/to/image -vga virtio -display sdl,gl=es`