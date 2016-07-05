librtmp-iOS
===========

librtmp build for iOS

http://www.davideccher.com/blog/wordpress/building-librtmp-for-ios/

mkdir openssl
cd openssl
curl http://www.openssl.org/source/openssl-1.0.1e.tar.gz -O openssl-1.0.1e.tar.gz
tar xfz openssl-1.0.1e.tar.gz

We’ll build all the release in the tmp folder.
Start to configure it for armv6.

?
mkdir openssl-1.0.1e-armv6
cd openssl-1.0.1e
./configure BSD-generic32 --openssldir=../openssl-1.0.1e-armv6
Now we has to edit Makefile and change


?
#edit Makefile and change
/Applications/Xcode.app/Contents/Developer/usr/bin/gcc -arch armv6
#CC= gcc with CC= /Applications/Xcode.app/Contents/Developer/usr/bin/gcc -arch armv6
# add to CFLAGS: -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk
This links are valid for my buildsystem, using SDK 5.0. Change it to  build for other buildsystem.

At this point we are ready to build.

?
make
make install
Now in /tmp/openssl-1.0.0g-armv6 we have the builded lib.

We do the same for armv7 and i386:

?
#ARMV7
cd ..
mkdir openssl-1.0.1e-armv7
cd openssl-1.0.1e
./configure BSD-generic32 --openssldir=../openssl-1.0.1e-armv7
#edit Makefile and change
CC= /Applications/Xcode.app/Contents/Developer/usr/bin/gcc -arch armv7
#CC= gcc with CC= /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc -arch armv7
#add to CLAGS: -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk
make
make install
 
#i386
mkdir openssl-1.0.1e-i386
cd openssl-1.0.1e
./configure BSD-generic32 --openssldir=../openssl-1.0.1e-i386
#edit Makefile and change
#CC= gcc with CC= /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc -arch i386
CC= /Applications/Xcode.app/Contents/Developer/usr/bin/gcc -arch i386
make
make install


At this point we can create an universal library using lipo.

?
cd ..
mkdir include
cp -r /tmp/openssl-1.0.1e-i386/include/ include/
mkdir lib
 
lipo /tmp/openssl-1.0.0g-armv6/lib/libcrypto.a /tmp/openssl-1.0.0g-armv7/lib/libcrypto.a /tmp/openssl-1.0.0g-i386/lib/libcrypto.a -create -output lib/libcrypto.a
lipo /tmp/openssl-1.0.0g-armv6/lib/libssl.a /tmp/openssl-1.0.0g-armv7/lib/libssl.a /tmp/openssl-1.0.0g-i386/lib/libssl.a -create -output lib/libssl.a
Now we have in our include and lib folder the the universal library of openssl.

To build librtmp for ios we build the three version of library like for openssl.

Starting cloning the last release

?
mkdir librtmp
cd librtmp
git clone git://git.ffmpeg.org/rtmpdump rtmpdump

To build the armv6 version of library make a copy of the source:

?
cp -r rtmpdump rtmpdump-armv6
cd rtmpdump-armv6/librtmp
#edit Makefile and set
#CC=$(CROSS_COMPILE)gcc -arch armv6
export CROSS_COMPILE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/
export XCFLAGS="-isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk -I/tmp/openssl/include/ -arch armv6"
export XLDFLAGS="-isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk -L/tmp/openssl/lib -arch armv6 "
make SYS=darwin
make SYS=darwin prefix=/tmp/librtmp-armv6 install
Change the path to export using the correct system build path  and the path of the openssl lib build before.


For the armv7

?
cp -r rtmpdump rtmpdump-armv7
cd rtmpdump-armv7/librtmp
#edit Makefile and change
#CC=$(CROSS_COMPILE)gcc -arch armv7
export CROSS_COMPILE=/Applications/Xcode.app/Contents/Developer/usr/bin/
export XCFLAGS="-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk -I/tmp/openssl/include/ -arch armv7"
export XLDFLAGS="-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk -L/tmp/openssl/lib -arch armv7"
make SYS=darwin
make SYS=darwin prefix=/tmp/librtmp-armv7 install

export CROSS_COMPILE=

For simulator

?
cd ..
cp -r rtmpdump rtmpdump-i386
cd rtmpdump-i386/librtmp
edit Makefile con
CC=$(CROSS_COMPILE)gcc -arch i386
export CROSS_COMPILE=/Applications/Xcode.app/Contents/Developer/usr/bin/

export XCFLAGS="-I/tmp/openssl/include/ -arch i386"
export XLDFLAGS="-L/tmp/openssl/lib -arch i386"

make SYS=darwin
make SYS=darwin prefix=/tmp/librtmp-i386 install
At this point we can create an universal library using lipo.

?
mkdir include
cp -r /tmp/librtmp-i386/include/librtmp include/
mkdir lib
lipo /tmp/librtmp-armv6/lib/librtmp.a /tmp/librtmp-armv7/lib/librtmp.a /tmp/librtmp-i386/lib/librtmp.a -create -output lib/librtmp.a

