vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO  libsdl-org/SDL_ttf
    REF ed5ca0e09ddc2b77f05498023262d622ea678946 # "release-${VERSION}"
    SHA512 0c90b4eb80598bb9f9564bfabd3e430bd2b5909e9191d462907347071f8ae793cbeeb6e977efb7188787de966626f77f9cce77f8fb5c4ea3d56ac2a875127871
    HEAD_REF main
    PATCHES
        fix-vendor.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        harfbuzz SDL3TTF_HARFBUZZ
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSDL3TTF_VENDORED=OFF
        -DSDL3TTF_SAMPLES=OFF
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
if(EXISTS "${CURRENT_PACKAGES_DIR}/cmake")
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL3_ttf CONFIG_PATH cmake)
else()
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL3_ttf CONFIG_PATH lib/cmake/SDL3_ttf)
endif()

vcpkg_fixup_pkgconfig()

if(NOT VCPKG_BUILD_TYPE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/sdl3-ttf.pc" "-lSDL2_ttf" "-lSDL3_ttfd")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/licenses")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
