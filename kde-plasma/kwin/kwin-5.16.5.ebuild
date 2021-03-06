# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_TEST="optional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Flexible, composited Window Manager for windowing systems on Linux"
LICENSE="GPL-2+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="caps gles2 multimedia"

COMMON_DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kglobalaccel '' '' '5=')
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kidletime '' '' '5=')
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwayland)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem X)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_plasma_dep breeze)
	$(add_plasma_dep kdecoration)
	$(add_plasma_dep kscreenlocker)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui 'gles2=' '' '5=')
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsensors)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	>=dev-libs/libinput-1.9
	>=dev-libs/wayland-1.2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libepoxy
	media-libs/mesa[egl,gbm,gles2?,wayland,X(+)]
	virtual/libudev:=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libdrm
	>=x11-libs/libxcb-1.10
	>=x11-libs/libxkbcommon-0.7.0
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	caps? ( sys-libs/libcap )
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kirigami)
	$(add_qt_dep qtquickcontrols)
	$(add_qt_dep qtquickcontrols2)
	$(add_qt_dep qtvirtualkeyboard)
	multimedia? ( $(add_qt_dep qtmultimedia 'gstreamer,qml') )
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep designer)
	$(add_qt_dep qtconcurrent)
	x11-base/xorg-proto
"
PDEPEND="
	$(add_plasma_dep kde-cli-tools)
"

RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare
	use multimedia || eapply "${FILESDIR}/${PN}-5.15.80-gstreamer-optional.patch"

	# Access violations, bug #640432
	sed -e "s/^ecm_find_qmlmodule.*QtMultimedia/#&/" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package caps Libcap)
	)

	kde5_src_configure
}
