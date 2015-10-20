################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="tzdata"
PKG_VERSION="2015g"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="Public Domain"
PKG_SITE="https://www.iana.org/time-zones"
#When updating dont forget to update tzcode link
PKG_URL="https://www.iana.org/time-zones/repository/releases/$PKG_NAME$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="timezone-data"
PKG_LONGDESC="timezone-data"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
mkdir -p $ROOT/$PKG_BUILD
tar xzf $ROOT/$SOURCES/tzdata/$PKG_NAME$PKG_VERSION.tar.gz -C $ROOT/$PKG_BUILD
wget https://www.iana.org/time-zones/repository/releases/tzcode2015g.tar.gz -P $ROOT/$SOURCES/tzdata/
tar xzf $ROOT/$SOURCES/tzdata/tzcode2015g.tar.gz -C $ROOT/$PKG_BUILD
#chmod -R u+rwX $ROOT/$PKG_BUILD/linux-tbs-drivers/*
}

make_target() {
  setup_toolchain host
  make CC="$HOST_CC" CFLAGS="$HOST_CFLAGS"
}

makeinstall_target() {
  make TOPDIR="./.install_pkg" install
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/share/zoneinfo
    mv $INSTALL/etc/zoneinfo/* $INSTALL/usr/share/zoneinfo

  rm -rf $INSTALL/man
  rm -rf $INSTALL/etc

  mkdir -p $INSTALL/etc
    ln -sf /var/run/localtime $INSTALL/etc/localtime
}

post_install() {
  enable_service tz-data.service
}
