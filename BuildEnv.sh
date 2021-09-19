#! /bin/bash

if [[ $EUID -ne 0 ]]
  then echo "Please run as root"; exit

else
apt -y install gdb qemu-system nasm build-essential tar bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo  libisl-dev

mkdir $HOME/src
cd $HOME/src

curl -O https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.bz2
curl -O https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz

tar -xjf binutils-2.37.tar.bz2
tar -xJf gcc-11.2.0.tar.xz

export PREFIX="$HOME/opt/cross"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH"


 
mkdir build-binutils
cd build-binutils
../binutils-2.37/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

cd $HOME/src
 
# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH
 
mkdir build-gcc
cd build-gcc
../gcc-11.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc



echo "export PATH=$PATH:$HOME/opt/cross/bin" >> ~/.bashrc

fi