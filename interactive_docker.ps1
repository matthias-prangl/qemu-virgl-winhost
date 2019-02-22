if ($args.count -lt 3) {
    write-host "Usage: interactive_docker.ps1 IMAGE_ID QEMU_SOURCE_PATH VIRGL_SOURCE_PATH"
    exit 1
}
$qemu_path = (convert-path $args[1])
$virgl_path = (convert-path $args[2])
$image_id = $args[0]


docker run  -v ${virgl_path}:/virglrenderer/ `
    -v ${qemu_path}:/qemu/ `
    -ti ${image_id} /bin/bash