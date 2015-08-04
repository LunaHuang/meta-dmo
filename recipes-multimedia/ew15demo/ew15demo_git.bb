# Copyright (C) 2015 Sebastian Wezel <swezel@data-modul.com>
# Released under the MIT license (see COPYING.MIT for the terms)

inherit qmake5

inherit dmo-launcher-app

DMO_LAUNCHER_EXEC = "/usr/bin/ew15demo"
DMO_LAUNCHER_NAME = "ew15Demo"
DMO_LAUNCHER_DESC = "Embedde World Multitouch Demo"
DMO_LAUNCHER_ICONPATH = "/usr/share/cinematicexperience-1.0/content/images/qt_logo.png"

DESCRIPTION = "Data Modul qt5 multitouch demo"
HOMEPAGE = "http://www.data-modul.com"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
SECTION = "graphics"
DEPENDS = "qtbase qtbase-native qtdeclarative"
RDEPENDS_${PN} = "qtbase qtdeclarative"

SRC_URI = " \
            git://git@emb.data-modul.com/userrepos/pst/ew15demo;protocol=ssh \
            "
SRCREV = "${AUTOREV}"
PV = "${SRCPV}"

OE_QMAKE_QMAKE_ORIG = "${STAGING_BINDIR_NATIVE}/${QT_DIR_NAME}//qmake"
OE_QMAKE_QMAKE = "bin/qmake"

S="${WORKDIR}/git"

do_configure() {
    if [ ! -e ${B}/bin/qmake ]; then
        mkdir ${B}/bin
        ln -sf ${OE_QMAKE_QMAKE_ORIG} ${B}/bin/qmake
    fi
    
    ${B}/bin/qmake ${S}/ew15demo.pro
}

do_install() {
    install -d ${D}/usr/bin
    install -m 755 ./ew15demo ${D}/usr/bin

}

PACKAGES = "${PN} ${PN}-dbg"

FILES_${PN} += "/usr/bin/ew15demo"
FILES_${PN}-dbg += "${datadir}/${P}/.dbug"

