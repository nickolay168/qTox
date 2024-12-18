set(CPACK_PACKAGE_VERSION_MAJOR 1)
set(CPACK_PACKAGE_VERSION_MINOR 17)
set(CPACK_PACKAGE_VERSION_PATCH 7)
set(CPACK_RPM_COMPONENT_INSTALL OFF)
set(CPACK_GENERATOR RPM)
set(CPACK_RPM_PACKAGE_ARCHITECTURE x86_64)
set(CPACK_RPM_PACKAGE_RELEASE_DIST fc41)
set(CPACK_RPM_FILE_NAME qtox-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${CPACK_RPM_PACKAGE_RELEASE_DIST}.${CPACK_RPM_PACKAGE_ARCHITECTURE}.rpm)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "[UNOFFICIAL] Feature-rich Tox Client")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/nickolay168/qTox")
set(CPACK_RPM_PACKAGE_LICENSE "GPLv3+ and BSD and CC-BY and CC-BY-SA")
set(CPACK_RPM_PACKAGE_DESCRIPTION "[UNOFFICIAL] qTox ia a powerful Tox client that follows the Tox design guidlines while running on all major platforms.")
set(CPACK_RESOURCE_FILE_LICENSE "LICENSE")
set(CPACK_RESOURCE_FILE_README "README.md")

include(CPack)