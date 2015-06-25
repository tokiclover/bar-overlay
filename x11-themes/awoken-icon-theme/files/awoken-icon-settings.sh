#!/bin/sh

:  ${ICONSET:=AwOken}
:  ${AWOKEN_RCFILE:=$HOME/.${ICONSET}rc}
:  ${LOCALDIR:=$HOME/.icons/$ICONSET}
:  ${ICONSDIR:=/usr/share/icons/$ICONSET}

# SCRIPT OPTIONS:
#   -F, --folder-type -> Folder type (it requires folder sub-type)
#   -f, --folder-sub-type -> Folder sub-type
#   -S, --start-here-type -> start-here
#   -T, --trash-type -> trash type
#   -G, --gedit-type -> gedit type
#   -C, --computer-type -> computer type
#   -H, --home-type -> home type
#   -c, --color -> color/no-color
#
# WARNING: "-c" option should be passed first,
#    otherwise "-G", "-C", "-H" could not work properly!

usage() {
  cat << EOF
  usage: ${0##*/} [OPTIONS]
  OPTIONS:
    -F -> Folder type (requires folder sub-type option)
    -f -> Folder sub-type                                                                
    -S -> start-here   
    -G -> gedit type     (deprecated)
    -T -> trash type     (deprecated)
    -C -> computer type  (deprecated)
    -H -> home type      (deprecated)
    -c -> color/no-color 
EOF
}

color() {
  for size in 128x128 24x24; do
    cd clear/$size/actions
    for i in *1.png; do
      case $i in
      (viewmag1.*|stock_zoom-1.*|application-x-font-type1.*|font-type1.*|font_type1.png) ;;
      (*) ln -fs $i ${i%1.*}.png;;
    esac
    done
    
    cd ../apps
    for i in *1.png; do
      case $i in
      (config-date1.*|glippy1.*|it.vodafone*|nm-stag*|selection1.*) ;;
      (*) ln -fs $i ${i%1.*}.png;;
    esac
    done
    cd ../
    
    for dir in categories devices mimetypes; do
      cd $dir
      for i in *1.png; do
        ln -fs $i ${i%1.*}.png
      done
      cd ../
    done
    
    cd places
    for i in *1.png; do
      case $i in
      (folder-linux1.*|user-trash1.*) ;;
      (*) ln -fs $i ${i%1.*}.png;;
    esac
    done
    cd ../../../
  done

  cd clear/22x22/actions
  echo 22x22
  for i in *1.png; do
    case $i in
    (viewmag1.*|stock_zoom-1.*) ;;
    (*) ln -fs $i ${i%1.*}.png;;
    esac
  done
  cd ../../../

  cd clear/22x22/apps
  for i in *1.png; do
    case $i in
    (viewmag1.*stock_zoom-1.*) ;;
    (*) ln -fs $i ${i%1.*}.png;;
    esac
  done
  cd ../../../

  cd clear/16x16/apps
  for i in *1.png; do
    ln -fs $i ${i%1.*}.png
  done
  cd ../../../

  cd clear/32x32/apps
  for i in *1.png; do
    ln -fs $i ${i%1.*}.png
  done
  cd ../../../

  cd clear/48x48/apps
  for i in *1.png; do
    ln -fs $i ${i%1.*}.png
  done
  cd ../../../
}

nocolor() {
  for size in 128x128 24x24; do
    cd clear/$size/
    for dir in actions categories devices mimetypes; do
      cd $dir
      for i in *2.png; do
        case $i in
          (playlist-layouts-22.*|application-x-sqlite2.*|audio-x-mp2.*|message-rfc822.*|txt2.png) ;;
		      (*) ln -fs $i ${i%2.*}.png;;
		    esac
      done
      cd ../
    done
    
    cd apps
    for i in *2.png; do
      case $i in
        (wincloser32.*|texmaker32x32.*|texmaker22x22.*|quake2.*|netbeans2.*)   ;;
	    	(glade-2.*|gnome-robots2.*|kexi-2.*|kexi2.*|gnobots2.*|config-date2.*) ;;
	    	(blueclock32.*|glippy2.*|it.vodafone*|nm-stage*|acetino2.*|onboard2.*) ;;
	    	(kmail2.*|control-center2.*|control-center2.*|selection2.*) ;;
	    	(*) ln -fs $i ${i%2.*}.png;;
	    esac
    done
    cd ../
    
    cd places
    for i in *2.png; do
      case $i in
        (folder-linux1.*|user-trash1.*) ;;
        (*) ln -fs $i ${i%1.*}.png;;
      esac
    done
    cd ../../../
  done
  
  cd clear/22x22/actions
  for i in *2.png; do
    ln -fs $i ${i%2.*}.png
  done
  cd ../../../

  cd clear/22x22/apps
  for i in *2.png; do
    ln -fs $i ${i%2.*}.png
  done
  cd ../../../

  cd clear/16x16/apps
  for i in *2.png; do
    ln -fs $i ${i%2.*}.png
  done
  cd ../../../

  cd clear/32x32/apps
  for i in *2.png; do
    ln -fs $i ${i%2.*}.png
  done
  cd ../../../

  cd clear/48x48/apps
  echo 48x48
  for i in *2.png; do
    ln -fs $i ${i%2.*}.png
  done
  cd ../../../
}

changefolder() {
  case "$type" in
    (awoken|classy|leaf|original|snowsabre|tlag)
      if [ -d clear/24x24/places/"$type/$subtype" ]; then
        type="$type/$subtype"
      else
        echo "ERROR: Invalid $subtype sub-type folder" >&2
        exit 4;
      fi
    ;;
    (s11)
      if [ -d clear/24x24/places/"$type/$subtype" ]; then
        type="s11/$type"
      else
        echo "ERROR: Invalid $subtype sub-type folder." >&2
        exit 4;
      fi
    ;;
    (metal|sonetto|token)
    ;;
    (*)
      echo "ERROR: Invalid $type type folder." >&2
      echo "ERROR: Checkout the type and sub-type folder theme!" >&2
      exit 3;
    ;;
  esac

  for size in 128x128 24x24; do
    dir=clear/$size/places
    for file in $dir/$type/*; do
      ln -fs $type/$file $file
    done
  done

  for size in 128x128 24x24; do
    dir=clear/$size/places/$type
    case "$type" in
  	  (s11/s11|s11/s11-original)
   	    ln -fs $dir/s11-folders/$subtype.png $dir/folder.png
      ;;
      (sonetto)
   	    ln -fs $dir/folder/$subtype.png $dir/folder.png
      ;;
    esac
  done
}

# Creating folder in $LOCALDIR directory if it doesn't exist                           #
if [ ! -d $LOCALDIR ]; then
  cp -dRf $ICONSDIR $LOCALDIR
fi
cd "$LOCALDIR"

ARGS="$(getopt -o hF:f:S:T:G:C:H:c: \
	-l help,folder-type:,folder-sub-type: \
	-l start-here-type:,trash-type:,gedit-type: \
	-l color:,computer-type:,home-type: \
	-n "${0##*/}" -s sh -- "${@}")"
[ "$?" = 0 ] || exit 1;
eval set -- $ARGS

for arg; do
  case "$1" in
    (-h|--help) usage; exit;;
    (-F|--folder-type) type="$2";;
    (-f|--folder-sub-type) subtype="$2";;
    (-S|--start-here-type) TARGET_KEY=start_here
      echo "Changing start here logo to $OPTARG..."
      for size in 128x128 24x24; do
        dir=clear/$size/places
        if [ -f ${dir%/*}/start-here/start-here-$2.png ]; then
          ln -fs ../start-here/start-here-$2.png $dir/start-here.png
        else
          echo "WARNING: Invalid $2 start-here theme." >&2
        fi
      done
    ;;
    (-T|--trash-type) TARGET_KEY="trash_type"
      echo "Changing trash icon to $2..."
      for size in 128x128 24x24; do
        dir=clear/$size/places
        if [ -f $dir/user-$2.png ]; then
          ln -fs user-$2.png $dir/user-trash.png
          ln -fs user-$2-full.png $dir/user-trash-full.png
        else
          echo "WARNING: Invalid $2 trash theme." >&2
        fi
      done
    ;;
    (-C|--computer-type) TARGET_KEY="computer_type"
	  name="$(echo "$2" | cut -c8-)"
      echo "Changing computer icon to $2..."
      for size in 128x128 24x24; do
        dir=clear/$size/places
        if [ -f $dir/user-desktop$name.png ]; then
          ln -fs user-desktop$name.png $dir/user-trash.png
        else
          echo "WARNING: Invalid $OPTARG computer theme." >&2
        fi
      done
    ;;
    (-H|--home-type) TARGET_KEY="home_type"
      echo "Changing home icon to $2..."
      for size in 128x128 24x24; do
        dir=clear/$size/places
        if [ -f $dir/user-$2.png ]; then
          ln -fs user-$2.png $dir/user-home.png
        else
          echo "WARNING: Invalid $OPTARG home theme." >&2
        fi
      done
    ;;
    (-c|--color) TARGET_KEY="color_type"
      echo "Changing color type to $2..."
      case "$2" in
		    (color) color;;
		    (nocolor) nocolor;;
        (*) echo "WARNING: Invalid color theme (supported: [no]color)" >&2;;
      esac
    ;;
  esac
  shift 2
done

if [ "$type" != "" ] && [ "$subtype" != "" ]; then
  TARGET_KEY="folder_type"
  echo "Changing folder type to $type $subtype..."
  changefolder
else
  echo "WARNING: No change done because of configuration mismatch"
fi
