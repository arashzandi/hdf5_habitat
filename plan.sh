pkg_name=hdf5
pkg_origin=bixu
pkg_version='1.10.4'
pkg_version_underscored=$(echo -n $pkg_version | sed 's@\.@_@g')
pkg_maintainer='Blake Irvin <blakeirvin@me.com>'
pkg_license=('bsd, hdf5')
pkg_source="https://s3.amazonaws.com/hdf-wordpress-1/wp-content/uploads/manual/HDF5/HDF5_$pkg_version_underscored/$pkg_name-$pkg_version.tar.gz"
pkg_shasum="8f60dc4dd6ab5fcd23c750d1dc5bca3d0453bdce5c8cdaf0a4a61a9d1122adb2"
pkg_deps=(core/glibc)
pkg_build_deps=(
  core/coreutils-static
  core/diffutils
  core/gcc
  core/make
  core/pcre
  core/zlib
)
pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)

do_prepare() {
  grep -lr '/bin/mv' . | while read f; do
    sed -e 's,/bin/mv,mv,g' -i "$f"
  done
  ./configure  --with-zlib=$(pkg_path_for core/zlib)/lib --prefix=$pkg_prefix
}

do_build() {
  make
}

do_install () {
  export LD_LIBRARY_PATH=$(pkg_path_for core/zlib)/lib
  make install
  make check-install
}
