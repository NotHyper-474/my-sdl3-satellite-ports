vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libsdl-org/SDL_image
    REF "preview-${VERSION}"
    SHA512 e139fd9474213757f473ca96cb7df78e6b122ac1a0f8b88e66d28955b8ee0390f83ee14dfe4f188aa4ba14b812c5522ce366e61a00609a3079930d68d8233921
    HEAD_REF main
    PATCHES
        fix-vendor.patch
        #fix-findwebp.patch
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        libjpeg-turbo SDL3IMAGE_JPG
        libwebp       SDL3IMAGE_WEBP
        tiff          SDL3IMAGE_TIF
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSDL3IMAGE_BACKEND_IMAGEIO=OFF
        -DSDL3IMAGE_BACKEND_STB=OFF
        -DSDL3IMAGE_DEPS_SHARED=OFF
        -DSDL3IMAGE_SAMPLES=OFF
        -DSDL3IMAGE_VENDORED=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if(EXISTS "${CURRENT_PACKAGES_DIR}/cmake")
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL3_image CONFIG_PATH cmake)
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/SDL3_image.framework/Resources")
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL3_image CONFIG_PATH SDL3_image.framework/Resources)
else()
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL3_image CONFIG_PATH lib/cmake/SDL3_image)
endif()

vcpkg_fixup_pkgconfig()

if(NOT VCPKG_BUILD_TYPE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/sdl3-image.pc" "-lSDL3_image" "-lSDL3_imaged")
endif()

file(REMOVE_RECURSE 
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/SDL3_image.framework"
    "${CURRENT_PACKAGES_DIR}/debug/SDL3_image.framework"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
