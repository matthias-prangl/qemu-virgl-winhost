if ($args.count -lt 1) {
    $image_tag = "fedora/qemuwin"
} else {
    $image_tag = $args[0]
}

$parent_path = (convert-path .\..\)
$qemu_path = ${parent_path} + "\qemu"
$virgl_path = ${parent_path} + "\virglrenderer"

if (!(test-path -path ${qemu_path})) {
    git clone https://github.com/matthias-prangl/qemu.git ${qemu_path}
}
if (!(test-path -path ${virgl_path})) {
    git clone https://github.com/matthias-prangl/virglrenderer.git ${virgl_path}
}

$qemu_path = (convert-path ".\..\qemu")
$virgl_path = (convert-path ".\..\virglrenderer")

docker build -t ${image_tag} .

.\build_qemu.ps1 ${image_tag} ${qemu_path} ${virgl_path}
