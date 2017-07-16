# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-video/ffmpeg/ffmpeg-3.0.9999.ebuild,v 1.5 2016/02/18 10:01:57 Exp $

EAPI=5

# Subslot: libavutil major.libavcodec major.libavformat major
# Since FFmpeg ships several libraries, subslot is kind of limited here.
# Most consumers will use those three libraries, if a "less used" library
# changes its soname, consumers will have to be rebuilt the old way
# (preserve-libs).
# If, for example, a package does not link to libavformat and only libavformat
# changes its ABI then this package will be rebuilt needlessly. Hence, such a
# package is free _not_ to := depend on FFmpeg but I would strongly encourage
# doing so since such a case is unlikely.
FFMPEG_SUBSLOT=55.57.57
FFMPEG_REVISION="${PV}"

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://source.ffmpeg.org/ffmpeg.git"
		EGIT_PROJECT="${PN}.git"
		case "${PV}" in
			(*.9999*) EGIT_BRANCH="release/${PV%.9999}";;
		esac;;
	(*)
		KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd \
			~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
		SRC_URI="http://ffmpeg.org/releases/${P/_/-}.tar.bz2"
		;;
esac
inherit eutils flag-o-matic multilib multilib-minimal toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec"
HOMEPAGE="http://ffmpeg.org/"

LICENSE_GPL="gpl? ( GPL-3 ) !gpl? ( LGPL-3 )"
LICENSE="${LICENSE_GPL}
	amr? ( ${LICENSE_GPL} )
	gmp? ( ${LICENSE_GPL} )
	encode? (
		amrenc? ( ${LICENSE_GPL} )
	)
	samba? ( GPL-3 )"
unset LICENSE_GPL
SLOT="0/${FFMPEG_SUBSLOT}"

# Options to use as use_enable in the foo[:bar] form.
# This will feed configure with $(use_enable foo bar)
# or $(use_enable foo foo) if no :bar is set.
# foo is added to IUSE.
FFMPEG_FLAGS=(
	+bzip2:bzlib cpudetection:runtime-cpudetect debug gcrypt gnutls gmp
	+gpl +hardcoded-tables +iconv lzma +network openssl +postproc
	samba:libsmbclient sdl:ffplay sdl cuda vaapi vdpau X:xlib xcb:libxcb
	xcb:libxcb-shm xcb:libxcb-xfixes +zlib
	# libavdevice options
	cdio:libcdio iec61883:libiec61883 ieee1394:libdc1394 libcaca openal
	opengl
	# indevs
	libv4l:libv4l2 pulseaudio:libpulse
	# decoders
	amr:libopencore-amrwb amr:libopencore-amrnb fdk:libfdk-aac
	jpeg2k:libopenjpeg bluray:libbluray celt:libcelt gme:libgme gsm:libgsm
	mmal modplug:libmodplug opus:libopus librtmp ssh:libssh
	schroedinger:libschroedinger speex:libspeex vorbis:libvorbis vpx:libvpx
	zvbi:libzvbi
	# libavfilter options
	bs2b:libbs2b chromaprint flite:libflite frei0r fribidi:libfribidi
	fontconfig ladspa libass truetype:libfreetype rubberband:librubberband
	zimg:libzimg
	# libswresample options
	libsoxr
	# Threads; we only support pthread for now but ffmpeg supports more
	+threads:pthreads
)

# Same as above but for encoders, i.e. they do something only with USE=encode.
FFMPEG_ENCODER_FLAGS=(
	amrenc:libvo-amrwbenc mp3:libmp3lame
	kvazaar:libkvazaar nvenc:nvenc
	openh264:libopenh264 snappy:libsnappy theora:libtheora twolame:libtwolame
	wavpack:libwavpack webp:libwebp x264:libx264 x265:libx265 xvid:libxvid
)
IUSE="alsa doc +encode jack oss pic static-libs test v4l
	${FFMPEG_FLAGS[@]%:*}
	${FFMPEG_ENCODER_FLAGS[@]%:*}"

# Strings for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
ARM_CPU_FEATURES=(v5te:armv5te v6:armv6 v6t2:armv6t2 neon:neon vfp:vfp)
MIPS_CPU_FEATURES=(dspr1:mipsdsp dspr2:mipsdspr2 fpu:mipsfpu msa:msa)
PPC_CPU_FEATURES=(altivec:altivec vsx:vsx power8:power8)
X86_CPU_FEATURES=(
	3dnow:amd3dnow 3dnowext:amd3dnowext avx:avx avx2:avx2 fma3:fma3 fma4:fma4
	mmx:mmx mmxext:mmxext sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4
	aes:aesni sse4_2:sse42 xop:xop
)
MIPS_CPU_REQUIRED_USE="
	cpu_flags_mips_msa? ( cpu_flags_mips_fpu )
"
PPC_CPU_REQUIRED_USE="
	cpu_flags_ppc_vsx? ( cpu_flags_ppc_altivec )
	cpu_flags_ppc_power8? ( cpu_flags_ppc_vsx )
"
X86_CPU_REQUIRED_USE="
	cpu_flags_x86_avx2? ( cpu_flags_x86_avx )
	cpu_flags_x86_fma4? ( cpu_flags_x86_avx )
	cpu_flags_x86_fma3? ( cpu_flags_x86_avx )
	cpu_flags_x86_xop?  ( cpu_flags_x86_avx )
	cpu_flags_x86_avx?  ( cpu_flags_x86_sse4_2 )
	cpu_flags_x86_aes? ( cpu_flags_x86_sse4_2 )
	cpu_flags_x86_sse4_2?  ( cpu_flags_x86_sse4_1 )
	cpu_flags_x86_sse4_1?  ( cpu_flags_x86_ssse3 )
	cpu_flags_x86_ssse3?  ( cpu_flags_x86_sse3 )
	cpu_flags_x86_sse3?  ( cpu_flags_x86_sse2 )
	cpu_flags_x86_sse2?  ( cpu_flags_x86_sse )
	cpu_flags_x86_sse?  ( cpu_flags_x86_mmxext )
	cpu_flags_x86_mmxext?  ( cpu_flags_x86_mmx )
	cpu_flags_x86_3dnowext?  ( cpu_flags_x86_3dnow )
	cpu_flags_x86_3dnow?  ( cpu_flags_x86_mmx )
"
# String for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
CPU_FEATURES=(
	${ARM_CPU_FEATURES[@]/#/cpu_flags_arm_}
	${MIPS_CPU_FEATURES[@]/#/cpu_flags_mips_}
	${PPC_CPU_FEATURES[@]/#/cpu_flags_ppc_}
	${X86_CPU_FEATURES[@]/#/cpu_flags_x86_}
)
IUSE+=" ${CPU_FEATURES[*]/%:*}"
unset {ARM,MIPS,PPC,X86}_CPU_FEATURES

FFTOOLS=(
	aviocat cws2fws ffescape ffeval ffhash fourcc2pixfmt
	graph2dot ismindex pktdumper qt-faststart sidxindex trasher
)
IUSE+=" ${FFTOOLS[@]/#/+fftools_}"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	amr? ( >=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}] )
	bluray? ( >=media-libs/libbluray-0.3.0-r1[${MULTILIB_USEDEP}] )
	bs2b? ( >=media-libs/libbs2b-3.1.0-r1[${MULTILIB_USEDEP}] )
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	cdio? (
		|| (
			>=dev-libs/libcdio-paranoia-0.90_p1-r1[${MULTILIB_USEDEP}]
			<dev-libs/libcdio-0.90[-minimal,${MULTILIB_USEDEP}]
		)
	)
	celt? ( >=media-libs/celt-0.11.1-r1[${MULTILIB_USEDEP}] )
	chromaprint? ( >=media-libs/chromaprint-1.2-r1[${MULTILIB_USEDEP}] )
	cuda? ( dev-util/nvidia-cuda-sdk )
	encode? (
		amrenc? ( >=media-libs/vo-amrwbenc-0.1.2-r1[${MULTILIB_USEDEP}] )
		kvazaar? ( media-libs/kvazaar[${MULTILIB_USEDEP}] )
		mp3? ( >=media-sound/lame-3.99.5-r1[${MULTILIB_USEDEP}] )
		nvenc? ( media-video/nvidia_video_sdk )
		openh264? ( >=media-libs/openh264-1.4.0-r1[${MULTILIB_USEDEP}] )
		theora? (
			>=media-libs/libtheora-1.1.1[encode,${MULTILIB_USEDEP}]
			>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
		)
		twolame? ( >=media-sound/twolame-0.3.13-r1[${MULTILIB_USEDEP}] )
		wavpack? ( >=media-sound/wavpack-4.60.1-r1[${MULTILIB_USEDEP}] )
		webp? ( >=media-libs/libwebp-0.3.0[${MULTILIB_USEDEP}] )
		x264? ( >=media-libs/x264-0.0.20130506:=[${MULTILIB_USEDEP}] )
		x265? ( >=media-libs/x265-1.6:=[${MULTILIB_USEDEP}] )
		xvid? ( >=media-libs/xvid-1.3.2-r1[${MULTILIB_USEDEP}] )
	)
	fdk? ( >=media-libs/fdk-aac-0.1.3[${MULTILIB_USEDEP}] )
	flite? ( >=app-accessibility/flite-1.4-r4[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	frei0r? ( media-plugins/frei0r-plugins )
	fribidi? ( >=dev-libs/fribidi-0.19.6[${MULTILIB_USEDEP}] )
	gcrypt? ( >=dev-libs/libgcrypt-1.6:0=[${MULTILIB_USEDEP}] )
	gme? ( >=media-libs/game-music-emu-0.6.0[${MULTILIB_USEDEP}] )
	gmp? ( >=dev-libs/gmp-6:0=[${MULTILIB_USEDEP}] )
	gnutls? ( >=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP}] )
	gsm? ( >=media-sound/gsm-1.0.13-r1[${MULTILIB_USEDEP}] )
	iconv? ( >=virtual/libiconv-0-r1[${MULTILIB_USEDEP}] )
	iec61883? (
		>=media-libs/libiec61883-1.2.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
		>=sys-libs/libavc1394-0.5.4-r1[${MULTILIB_USEDEP}]
	)
	ieee1394? (
		>=media-libs/libdc1394-2.2.1[${MULTILIB_USEDEP}]
		>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
	)
	jack? ( >=media-sound/jack-audio-connection-kit-0.121.3-r1[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/openjpeg-2:2[${MULTILIB_USEDEP}] )
	libass? ( >=media-libs/libass-0.10.2[${MULTILIB_USEDEP}] )
	libcaca? ( >=media-libs/libcaca-0.99_beta18-r1[${MULTILIB_USEDEP}] )
	librtmp? ( >=media-video/rtmpdump-2.4_p20131018[${MULTILIB_USEDEP}] )
	libsoxr? ( >=media-libs/soxr-0.1.0[${MULTILIB_USEDEP}] )
	libv4l? ( >=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}] )
	mmal? ( media-libs/raspberrypi-userland )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	openal? ( >=media-libs/openal-1.15.1[${MULTILIB_USEDEP}] )
	opengl? ( >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
	openssl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
	opus? ( >=media-libs/opus-1.0.2-r2[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	rubberband? ( >=media-libs/rubberband-1.8.1-r1[${MULTILIB_USEDEP}] )
	samba? ( >=net-fs/samba-3.6.23-r1[${MULTILIB_USEDEP}] )
	schroedinger? ( >=media-libs/schroedinger-1.0.11-r1[${MULTILIB_USEDEP}] )
	sdl? ( >=media-libs/libsdl-1.2.15-r4[sound,video,${MULTILIB_USEDEP}] )
	speex? ( >=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}] )
	ssh? ( >=net-libs/libssh-0.5.5[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}] )
	vaapi? ( >=x11-libs/libva-1.2.1-r1[${MULTILIB_USEDEP}] )
	vdpau? ( >=x11-libs/libvdpau-0.7[${MULTILIB_USEDEP}] )
	vorbis? (
		>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	)
	vpx? ( >=media-libs/libvpx-1.4.0[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
		>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
	)
	xcb? ( x11-libs/libxcb[${MULTILIB_USEDEP}] )
	zimg? ( media-libs/zimg[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	zvbi? ( >=media-libs/zvbi-0.2.35[${MULTILIB_USEDEP}] )
	!media-video/qt-faststart
	!media-libs/libpostproc
"
DEPEND="${RDEPEND}
	>=sys-devel/make-3.81
	doc? ( sys-apps/texinfo )
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	ladspa? ( >=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}] )
	cpu_flags_x86_mmx? ( >=dev-lang/yasm-1.2 )
	test? ( net-misc/wget sys-devel/bc )
	v4l? ( sys-kernel/linux-headers )
"
RDEPEND="${RDEPEND}
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20140508-r3
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

# Code requiring FFmpeg to be built under gpl license
GPL_REQUIRED_USE="postproc? ( gpl )
	frei0r? ( gpl )
	cdio? ( gpl )
	samba? ( gpl )
	encode? (
		x264? ( gpl )
		x265? ( gpl )
		xvid? ( gpl )
		X? ( !xcb? ( gpl ) )
	)
"
REQUIRED_USE="	libv4l? ( v4l )
	fftools_cws2fws? ( zlib )
	test? ( encode )
	${GPL_REQUIRED_USE}
	${MIPS_CPU_REQUIRED_USE}
	${PPC_CPU_REQUIRED_USE}
	${X86_CPU_REQUIRED_USE}"
unset GPL_REQUIRED_USE {MIPS,PPC,X86}_CPU_REQUIRED_USE
RESTRICT="
	gpl? ( openssl? ( bindist ) fdk? ( bindist ) )"

DOCS=( Changelog README.md CREDITS doc/APIchanges )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libavutil/avconfig.h
)

src_prepare()
{
	epatch_user
}

multilib_src_configure()
{
	local -a myeconfargs=( ${EXTRA_FFMPEG_CONF} )

	# options to use as use_enable in the foo[:bar] form.
	# This will feed configure with $(use_enable foo bar)
	# or $(use_enable foo foo) if no :bar is set.
	local ffuse=( "${FFMPEG_FLAGS[@]}" )
	use openssl && myeconfargs+=( --enable-nonfree )
	use samba && myeconfargs+=( --enable-version3 )

	# Encoders
	if use encode; then
		ffuse+=( "${FFMPEG_ENCODER_FLAGS[@]}" )

		# Licensing.
		if use amrenc ; then
			myeconfargs+=( --enable-version3 )
		fi
	else
		myeconfargs+=( --disable-encoders )
	fi

	# Indevs
	use v4l || myeconfargs+=( --disable-indev=v4l2 --disable-outdev=v4l2 )
	for i in alsa oss jack ; do
		use "${i}" || myeconfargs+=( "--disable-indev=${i}" )
	done
	use xcb || ffuse+=( X:x11grab )

	# Outdevs
	for i in alsa oss sdl ; do
		use ${i} || myeconfargs+=( "--disable-outdev=${i}" )
	done

	# Decoders
	use amr && myeconfargs+=( --enable-version3 )
	use gmp && myeconfargs+=( --enable-version3 )
	use fdk && myeconfargs+=( --enable-nonfree )

	ffuse=(${ffuse[@]/+/})
	for (( i=0; i<${#ffuse[@]}; i++ )); do
		myeconfargs+=( $(use_enable "${ffuse[i]%:*}" "${ffuse[i]#*:}") )
	done

	# (temporarily) disable non-multilib deps
	if ! multilib_is_native_abi; then
		for i in frei0r ; do
			myeconfargs+=( "--disable-${i}" )
		done
	fi

	# CPU features
	for (( i=0; i<${#CPU_FEATURES[@]}; i++ )); do
		use ${CPU_FEATURES[i]%:*} || myeconfargs+=( "--disable-${CPU_FEATURES[i]#*:}" )
	done
	if use pic ; then
		myeconfargs+=( --enable-pic )
		# disable asm code if PIC is required
		# as the provided asm decidedly is not PIC for x86.
		case "${ABI}" in
			(x86) myeconfargs+=( --disable-asm );;
		esac
	fi
	case "${ABI}" in
		(x32) myeconfargs+=( --disable-asm ) ;; #427004
	esac

	# Try to get cpu type based on CFLAGS.
	# Bug #172723
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	for i in $(get-flag march) $(get-flag mcpu) $(get-flag mtune) ; do
		case "${i}" in
			(native) i="host";; # bug #273421
		esac
		myeconfargs+=( "--cpu=${i}" )
		break
	done

	# LTO support, bug #566282
	is-flagq "-flto*" && myeconfargs+=( "--enable-lto" )

	# Mandatory configuration
	myeconfargs+=(
		--enable-gpl
		--enable-postproc
		--enable-avfilter
		--enable-avresample
		--disable-stripping
	)

	# cross compile support
	if tc-is-cross-compiler ; then
		myeconfargs+=( --enable-cross-compile
			"--arch=$(tc-arch-kernel)"
			"--cross-prefix=${CHOST}-"
		)
		case "${CHOST}" in
			(*freebsd*) myeconfargs+=( --target-os=freebsd );;
			(mingw32*)  myeconfargs+=( --target-os=mingw32 );;
			(*linux*)   myeconfargs+=( --target-os=linux )  ;;
		esac
	fi

	# doc
	myeconfargs+=(
		$(multilib_native_use_enable doc)
		$(multilib_native_use_enable doc htmlpages)
		$(multilib_native_enable manpages)
	)

	myeconfargs+=(
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--shlibdir="${EPREFIX}/usr/$(get_libdir)"
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--mandir="${EPREFIX}/usr/share/man"
		--enable-shared
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
		--ar="$(tc-getAR)"
		--optflags="${CFLAGS}"
		--extra-cflags="${CFLAGS}"
		--extra-cxxflags="${CXXFLAGS}"
		$(use_enable static-libs static)
	)
	echo configure "${myeconfargs[@]}"
	"${S}"/configure "${myeconfargs[@]}" || die
}

multilib_src_compile()
{
	emake V=1

	if multilib_is_native_abi; then
		for (( i=0; i<${#FFTOOLS[@]}; i++ )); do
			use fftools_${FFTOOLS[i]} && emake V=1 tools/${FFTOOLS[i]}
		done
	fi
}

multilib_src_install()
{
	emake V=1 DESTDIR="${D}" install install-doc

	if multilib_is_native_abi; then
		for (( i=0; i<${#FFTOOLS[@]}; i++ )); do
			use fftools_${FFTOOLS[i]} && dobin tools/${FFTOOLS[i]}
		done
	fi
}

multilib_src_install_all()
{
	[ -f RELEASE_NOTES ] && DOCS+=( RELEASE_NOTES )
	dodoc "${DOCS[@]}" doc/*.txt
}

multilib_src_test()
{
	local MULTILIB_WRAPPED_HEADERS
	LD_LIBRARY_PATH="${BUILD_DIR}/libpostproc:${BUILD_DIR}/libswscale"
	LD_LIBRARY_PATH+=":${BUILD_DIR}/libswresample:${BUILD_DIR}/libavcodec"
	LD_LIBRARY_PATH+=":${BUILD_DIR}/libavdevice:${BUILD_DIR}/libavfilter"
	LD_LIBRARY_PATH+=":${BUILD_DIR}/libavformat:${BUILD_DIR}/libavutil"
	LD_LIBRARY_PATH+=":${BUILD_DIR}/libavresample"

	emake V=1 fate
}

unset i
