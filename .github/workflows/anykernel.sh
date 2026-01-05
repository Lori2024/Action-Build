# AnyKernel3 Ramdisk Mod Script for OnePlus SM8250
# Based on osm0sis @ xda-developers template

properties() { '
kernel.string=OnePlus 8 Series Kernel (Docker/BPF Enabled)
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
supported.versions=11, 12, 13, 14
'; }

# 权限设置
attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
}

# 核心分区配置
block=auto; # 自动识别 boot 分区
is_slot_device=auto; # 自动识别 A/B 分区
ramdisk_compression=auto;
patch_vbmeta_flag=auto; # 自动修复 vbmeta 避免开启验证失败

# 导入核心库
. tools/ak3-core.sh && attributes;

# 解包 boot.img
dump_boot;

# --- 自定义修改开始 ---

# 优化 cgroup 挂载，这对于 Docker 在 Android 上的稳定性至关重要
backup_file init.rc;
replace_string init.rc "cpuctl cpu,timer_slack" "mount cgroup none /dev/cpuctl cpu" "mount cgroup none /dev/cpuctl cpu,timer_slack";

# --- 自定义修改结束 ---

# 打包并写回分区
write_boot;
