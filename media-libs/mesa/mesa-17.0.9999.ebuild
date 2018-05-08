# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/mesa/mesa-9999.ebuild,v 1.7 2016/06/06 22:15:06 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit llvm autotools-multilib flag-o-matic python-any-r1 pax-utils

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		inherit git-2
		EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		case "${PV}" in
			(*.9999*) EGIT_BRANCH="${PV%.9999*}"
				PATCHES=("${FILESDIR}"/glx_ro_text_segm.patch)
			;;
			(*) EXPERIMENTAL=true
			;;
		esac
		DEPEND="sys-devel/bison
	sys-devel/flex
	${PYTHON_DEPS}
	$(python_gen_any_dep ">=dev-python/mako-0.8.0[\${PYTHON_USEDEP}]")"
		;;
	(*)
		KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc \
			~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux \
			~ia64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
		SRC_URI="ftp://ftp.freedesktop.org/pub/${PN}/${PV/_rc*/}/${P/_/-}.tar.xz"
		;;
esac

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"

# The code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"
SLOT="0/${PV:0:4}"
RESTRICT="!bindist? ( bindist )"

INTEL_CARDS=(i915 i965 imx intel)
RADEON_CARDS=(r100 r200 r300 r600 radeon radeonsi)
CARDS_LIST=(
	${INTEL_CARDS[@]}
	${RADEON_CARDS[@]}
	freedreno nouveau vc4 virgl vivante vmware
)

IUSE="${CARDS_LIST[@]/#/video_cards_}
	bindist +classic d3d9 debug +dri3 +egl +gallium +gbm gles1 gles2 unwind
	+llvm +nptl opencl osmesa pax_kernel openmax pic selinux vaapi valgrind
	vdpau vulkan wayland xvmc xa kernel_FreeBSD"

REQUIRED_USE="
	d3d9? ( gallium dri3 )
	llvm?   ( gallium )
	opencl? ( gallium llvm )
	openmax? ( gallium )
	gles1?  ( egl )
	gles2?  ( egl )
	vaapi? ( gallium )
	vdpau? ( gallium )
	vulkan? ( || ( video_cards_i965 video_cards_radeonsi )
			  video_cards_radeonsi? ( llvm ) )
	wayland? ( egl gbm )
	xa?  ( gallium )
	video_cards_freedreno?  ( gallium )
	video_cards_intel?  ( classic )
	video_cards_i915?   ( || ( classic gallium ) )
	video_cards_i965?   ( classic )
	video_cards_imx?    ( gallium video_cards_vivante )
	video_cards_nouveau? ( || ( classic gallium ) )
	video_cards_radeon? ( || ( classic gallium )
						  gallium? ( x86? ( llvm ) amd64? ( llvm ) ) )
	video_cards_r100?   ( classic )
	video_cards_r200?   ( classic )
	video_cards_r300?   ( gallium x86? ( llvm ) amd64? ( llvm ) )
	video_cards_r600?   ( gallium )
	video_cards_radeonsi?   ( gallium llvm )
	video_cards_vc4? ( gallium )
	video_cards_virgl? ( gallium )
	video_cards_vivante? ( gallium gbm )
	video_cards_vmware? ( gallium )
	${PYTHON_REQUIRED_USE}
"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.89"
# keep correct libdrm and dri2proto dep
# keep blocks in rdepend for binpkg
RDEPEND="
	!<x11-base/xorg-server-1.7
	!<=x11-proto/xf86driproto-2.0.3
	classic? ( app-eselect/eselect-mesa )
	gallium? ( app-eselect/eselect-mesa )
	app-eselect/eselect-opengl
	dev-libs/expat[${MULTILIB_USEDEP}]
	gbm? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	dri3? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	x11-libs/libX11:=[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence:=[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:=[${MULTILIB_USEDEP}]
	x11-libs/libXext:=[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm:=[${MULTILIB_USEDEP}]
	x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:=[${MULTILIB_USEDEP}]
	unwind? ( sys-libs/libunwind[${MULTILIB_USEDEP}] )
	llvm? (
		video_cards_radeonsi? ( 
			virtual/libelf:0=[${MULTILIB_USEDEP}]
			)
		video_cards_r600? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
		video_cards_radeon? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
		sys-devel/llvm:=[${MULTILIB_USEDEP}]
	)
	opencl? (
				app-eselect/eselect-opencl
				dev-libs/libclc
				virtual/libelf:0=[${MULTILIB_USEDEP}]
			)
	openmax? (
		media-libs/libomxil-bellagio:=[${MULTILIB_USEDEP}]
		x11-misc/xdg-utils
	)
	vaapi? (
		x11-libs/libva:=[${MULTILIB_USEDEP}]
		video_cards_nouveau? ( !<=x11-libs/libva-vdpau-driver-0.7.4-r3 )
	)
	valgrind? ( dev-util/valgrind )
	vdpau? ( x11-libs/libvdpau:=[${MULTILIB_USEDEP}] )
	wayland? (
		dev-libs/wayland:=[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.8
	)
	xvmc? ( x11-libs/libXvMC:=[${MULTILIB_USEDEP}] )
	${LIBDRM_DEPSTRING}[video_cards_freedreno?,video_cards_nouveau?,video_cards_vc4,video_cards_vivante,video_cards_vmware?,${MULTILIB_USEDEP}]
	video_cards_intel? (
		!video_cards_i965? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	)
"
for card in "${INTEL_CARDS[@]}"; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	"
done

for card in "${RADEON_CARDS[@]}"; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_radeon] )
	"
done
RDEPEND="${RDEPEND}
	video_cards_radeonsi? ( ${LIBDRM_DEPSTRING}[video_cards_amdgpu] )
"
unset card INTEL_CARDS RADEON_CARDS CARDS_LIST

# Please keep the LLVM dependency block separate. Since LLVM is slotted,
# we need to *really* make sure we're not pulling one than more slot
# simultaneously.
#
# How to use it:
# 1. List all the working slots (with min versions) in ||, newest first.
# 2. Update the := to specify *max* version, e.g. < 7.
# 3. Specify LLVM_MAX_SLOT, e.g. 6.
LLVM_MAX_SLOT="5"
LLVM_DEPSTR="
	|| (
		sys-devel/llvm:5[${MULTILIB_USEDEP}]
		sys-devel/llvm:4[${MULTILIB_USEDEP}]
		>=sys-devel/llvm-3.9.0:0[${MULTILIB_USEDEP}]
	)
	<sys-devel/llvm-6:=[${MULTILIB_USEDEP}]
"
LLVM_DEPSTR_AMDGPU=${LLVM_DEPSTR//]/,llvm_targets_AMDGPU(-)]}
CLANG_DEPSTR=${LLVM_DEPSTR//llvm/clang}
CLANG_DEPSTR_AMDGPU=${CLANG_DEPSTR//]/,llvm_targets_AMDGPU(-)]}
RDEPEND="${RDEPEND}
	llvm? (
		opencl? (
			video_cards_r600? (
				${CLANG_DEPSTR_AMDGPU}
			)
			!video_cards_r600? (
				video_cards_radeonsi? (
					${CLANG_DEPSTR_AMDGPU}
				)
			)
			!video_cards_r600? (
				!video_cards_radeonsi? (
					video_cards_radeon? (
						${CLANG_DEPSTR_AMDGPU}
					)
				)
			)
			!video_cards_r600? (
				!video_cards_radeon? (
					!video_cards_radeonsi? (
						${CLANG_DEPSTR}
					)
				)
			)
		)
		!opencl? (
			video_cards_r600? (
				${LLVM_DEPSTR_AMDGPU}
			)
			!video_cards_r600? (
				video_cards_radeonsi? (
					${LLVM_DEPSTR_AMDGPU}
				)
			)
			!video_cards_r600? (
				!video_cards_radeonsi? (
					video_cards_radeon? (
						${LLVM_DEPSTR_AMDGPU}
					)
				)
			)
			!video_cards_r600? (
				!video_cards_radeon? (
					!video_cards_radeonsi? (
						${LLVM_DEPSTR}
					)
				)
			)
		)
		video_cards_radeonsi? ( sys-devel/llvm[video_cards_radeon] )
	)
"
unset {LLVM,CLANG}_DEPSTR{,_AMDGPU}

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	opencl? (
		>=sys-devel/gcc-4.6
	)
	sys-devel/gettext
	virtual/pkgconfig
	valgrind? ( dev-util/valgrind )
	>=x11-proto/dri2proto-2.8-r1:=[${MULTILIB_USEDEP}]
	dri3? (
		x11-proto/dri3proto[${MULTILIB_USEDEP}]
		x11-proto/presentproto[${MULTILIB_USEDEP}]
	)
	x11-proto/glproto[${MULTILIB_USEDEP}]
	x11-proto/xextproto[${MULTILIB_USEDEP}]
	x11-proto/xf86driproto[${MULTILIB_USEDEP}]
	x11-proto/xf86vidmodeproto[${MULTILIB_USEDEP}]
	vulkan? (
		$(python_gen_any_dep ">=dev-python/mako-0.7.3[\${PYTHON_USEDEP}]")
	)
"

QA_WX_LOAD="
x86? (
	!pic? (
		usr/lib*/libglapi.so.0.0.0
		usr/lib*/libGLESv1_CM.so.1.1.0
		usr/lib*/libGLESv2.so.2.0.0
		usr/lib*/libGL.so.1.2.0
		usr/lib*/libOSMesa.so.8.0.0
	)
)"

llvm_check_deps() {
	local flags=${MULTILIB_USEDEP}
	if use video_cards_r600 || use video_cards_radeon || use video_cards_radeonsi
	then
		flags+=",llvm_targets_AMDGPU(-)"
	fi

	if use opencl; then
		has_version "sys-devel/clang[${flags}]" || return 1
	fi
	has_version "sys-devel/llvm[${flags}]"
}

OPENGL_DIR="xorg-x11"
FOLDER="${PV/_rc*/}"

pkg_setup() {
	# warning message for bug 459306
	if use llvm && has_version sys-devel/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in media-libs/mesa and sys-devel/llvm"
		ewarn "detected! This can cause problems. For details, see bug 459306."
	fi

	if use llvm; then
		llvm_pkg_setup
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	autotools-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	local -a myeconfargs=( ${EXTRA_MESA_CONF} )

	if use classic; then
	# Configurable DRI drivers
		driver_enable DRI swrast

	# Intel code
		driver_enable DRI video_cards_i915 i915
		driver_enable DRI video_cards_i965 i965
		if ! use video_cards_i915 && \
			! use video_cards_i965; then
			driver_enable DRI video_cards_intel i915 i965
		fi

		# Nouveau code
		driver_enable DRI video_cards_nouveau nouveau

		# ATI code
		driver_enable DRI video_cards_r100 radeon
		driver_enable DRI video_cards_r200 r200
		if ! use video_cards_r100 && \
				! use video_cards_r200; then
			driver_enable DRI video_cards_radeon radeon r200
		fi
	fi

	if use egl; then
		myeconfargs+=( "--with-platforms=x11$(usex wayland ',wayland' '')$(usex gbm ',drm')" )
	fi

	if use gallium; then
		myeconfargs+=(
			$(use_enable d3d9 nine)
			$(use_enable llvm)
			$(use_enable openmax omx-bellagio)
			$(use_enable vaapi va)
			$(use_enable vdpau)
			$(use_enable xa)
			$(use_enable xvmc)
			$(usex vaapi "--with-va-libdir=/usr/$(get_libdir)/va/drivers" "")
		)
		driver_enable GALLIUM swrast
		driver_enable GALLIUM video_cards_vc4 vc4
		driver_enable GALLIUM video_cards_vivante etnaviv
		driver_enable GALLIUM video_cards_vmware svga
		driver_enable GALLIUM video_cards_nouveau nouveau
		driver_enable GALLIUM video_cards_i915 i915
		driver_enable GALLIUM video_cards_imx imx
		if ! use video_cards_i915 && \
			! use video_cards_i965; then
			driver_enable GALLIUM video_cards_intel i915
		fi

		driver_enable GALLIUM video_cards_r300 r300
		driver_enable GALLIUM video_cards_r600 r600
		driver_enable GALLIUM video_cards_radeonsi radeonsi
		if ! use video_cards_r300 && \
				! use video_cards_r600; then
			driver_enable GALLIUM video_cards_radeon r300 r600
		fi

		driver_enable GALLIUM video_cards_freedreno freedreno
		# opencl stuff
		if use opencl; then
			myeconfargs+=(
				$(use_enable opencl)
				--with-clang-libdir="${EPREFIX}/usr/lib"
			)
		fi
		driver_enable GALLIUM video_cards_virgl virgl
	fi

	if use vulkan; then
		driver_enable VULKAN video_cards_i965 intel
		driver_enable VULKAN video_cards_radeonsi radeon
	fi

	# x86 hardened pax_kernel needs glx-rts, bug 240956
	if use pax_kernel; then
		myeconfargs+=( $(use_enable x86 glx-rts) )
	fi

	# on abi_x86_32 hardened we need to have asm disable  
	case "${ABI}" in
		(x86*)
			use pic && myeconfargs+=( --disable-asm )
			;;
	esac

	if use gallium; then
		myconf+=" $(use_enable osmesa gallium-osmesa)"
	else
		myconf+=" $(use_enable osmesa)"
	fi

	# build fails with BSD indent, bug #428112
	use userland_GNU || export INDENT=cat

	myeconfargs+=(
		--enable-dri
		--enable-glx=dri
		--enable-shared-glapi
		--disable-shader-cache
		$(use_enable !bindist texture-float)
		$(use_enable d3d9 nine)
		$(use_enable debug)
		$(use_enable dri3)
		$(use_enable egl)
		$(use_enable gbm)
		$(use_enable gles1)
		$(use_enable gles2)
		$(use_enable nptl glx-tls)
		$(use_enable unwind libunwind)
		--enable-valgrind="$(usex valgrind auto no)"
		--enable-llvm-shared-libs
		--with-dri-drivers="${DRI_DRIVERS}"
		--with-gallium-drivers="${GALLIUM_DRIVERS}"
		--with-vulkan-drivers="${VULKAN_DRIVERS}"
		PYTHON2="${PYTHON}"
	)
	autotools-utils_src_configure
}

multilib_src_install() {
	emake install DESTDIR="${D}"

	if use classic || use gallium; then
			ebegin "Moving DRI/Gallium drivers for dynamic switching"
			local gallium_drivers=( i915_dri.so i965_dri.so r300_dri.so r600_dri.so swrast_dri.so )
			keepdir /usr/$(get_libdir)/dri
			dodir /usr/$(get_libdir)/mesa
			for x in ${gallium_drivers[@]}; do
				if [ -f "$(get_libdir)/gallium/${x}" ]; then
					mv -f "${ED}/usr/$(get_libdir)/dri/${x}" "${ED}/usr/$(get_libdir)/dri/${x/_dri.so/g_dri.so}" \
						|| die "Failed to move ${x}"
				fi
			done
			if use classic; then
				emake -C "${BUILD_DIR}/src/mesa/drivers/dri" DESTDIR="${D}" install
			fi
			for x in "${ED}"/usr/$(get_libdir)/dri/*.so; do
				if [ -f ${x} -o -L ${x} ]; then
					mv -f "${x}" "${x/dri/mesa}" \
						|| die "Failed to move ${x}"
				fi
			done
			pushd "${ED}"/usr/$(get_libdir)/dri || die "pushd failed"
			ln -s ../mesa/*.so . || die "Creating symlink failed"
			# remove symlinks to drivers known to eselect
			for x in "${gallium_drivers[@]}"; do
				if [ -f "${x}" -o -L "${x}" ]; then
					rm "${x}" || die "Failed to remove ${x}"
				fi
			done
			popd
		eend "${?}"
	fi
	if use opencl; then
		ebegin "Moving Gallium/Clover OpenCL implementation for dynamic switching"
		local cl_dir="/usr/$(get_libdir)/OpenCL/vendors/mesa"
		dodir ${cl_dir}/{lib,include}
		if [ -f "${ED}/usr/$(get_libdir)/libOpenCL.so" ]; then
			mv -f "${ED}"/usr/$(get_libdir)/libOpenCL.so* \
			"${ED}"${cl_dir}
		fi
		if [ -f "${ED}/usr/include/CL/opencl.h" ]; then
			mv -f "${ED}"/usr/include/CL \
			"${ED}"${cl_dir}/include
		fi
		eend "${?}"
	fi

	if use openmax; then
		echo "XDG_DATA_DIRS=\"${EPREFIX}/usr/share/mesa/xdg\"" > "${T}/99mesaxdgomx"
		doenvd "${T}"/99mesaxdgomx
		keepdir /usr/share/mesa/xdg
	fi
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs

	if use !bindist; then
		dodoc docs/patents.txt
	fi

	# Install config file for eselect mesa
	insinto /usr/share/mesa
	newins "${FILESDIR}/eselect-mesa.conf.9.2" eselect-mesa.conf
}

multilib_src_test() {
	if use llvm; then
		local llvm_tests='lp_test_arit lp_test_arit lp_test_blend lp_test_blend lp_test_conv lp_test_conv lp_test_format lp_test_format lp_test_printf lp_test_printf'
		pushd src/gallium/drivers/llvmpipe >/dev/null || die
		emake ${llvm_tests}
		pax-mark m ${llvm_tests}
		popd >/dev/null || die
	fi
	emake check
}

pkg_postinst() {
	# Switch to the xorg implementation.
	echo
	eselect opengl set --use-old ${OPENGL_DIR}

	# Select classic/gallium drivers
	if use classic || use gallium; then
		eselect mesa set --auto
	fi

	# Switch to mesa opencl
	if use opencl; then
		eselect opencl set --use-old ${PN}
	fi

	# run omxregister-bellagio to make the OpenMAX drivers known system-wide
	if use openmax; then
		ebegin "Registering OpenMAX drivers"
		BELLAGIO_SEARCH_PATH="${EPREFIX}/usr/$(get_libdir)/libomxil-bellagio0" \
			OMX_BELLAGIO_REGISTRY=${EPREFIX}/usr/share/mesa/xdg/.omxregister \
			omxregister-bellagio
		eend $?
	fi

	# warn about patent encumbered texture-float
	if use !bindist; then
		elog "USE=\"bindist\" was not set. Potentially patent encumbered code was"
		elog "enabled. Please see /usr/share/doc/${P}/patents.txt.bz2 for an"
		elog "explanation."
	fi
}

pkg_prerm() {
	if use openmax; then
		rm "${EPREFIX}"/usr/share/mesa/xdg/.omxregister
	fi
}

# other args - names of DRI drivers to enable
driver_enable() {
	local list=DRI
	case "${1}" in
		(DRI|GALLIUM|VULKAN) list="${1}"; shift;;
	esac

	case "${#}" in
		# for enabling unconditionally
		(1)
			eval ${list}_DRIVERS=\"\$${list}_DRIVERS,${1}\"
			;;
		(*)
			local u
			if use "${1}"; then
				shift
				for u; do
					eval ${list}_DRIVERS=\"\$${list}_DRIVERS,${u}\"
				done
			fi
			;;
	esac
}
