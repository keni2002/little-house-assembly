$archivo_asm = $args[0]


fasm $archivo_asm
$archivo_img = $archivo_asm.Replace(".asm", ".img")

qemu-system-x86_64.exe -fda $archivo_img