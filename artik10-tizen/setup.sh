# Check out Kernel source with correct brand, and configure customization for Artik

TIZEN_USER=rteem

git clone ssh://TIZEN_USER@review.tizen.org:29418/platform/kernel/linux-exynos
cd linux-exynos
git checkout -b tizen origin/tizen

cp ../exynos5422-artik10.dts arch/arm/boot/dts/exynos5422-artik10.dts

cp ../artik10_defconfig arch/arm/configs/artik10_defconfig
cp ../build_kernel.sh .
./build_kernel.sh
