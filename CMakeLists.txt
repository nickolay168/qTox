################################################################################
#
# :: CMake configuration
#
################################################################################

cmake_minimum_required(VERSION 2.8.11)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

set(ENV{PKG_CONFIG_PATH}
  ${CMAKE_SOURCE_DIR}/libs/lib/pkgconfig:/opt/ffmpeg/lib/pkgconfig:$ENV{PKG_CONFIG_PATH})
set(ENV{PKG_CONFIG_PATH_i686_w64_mingw32_shared}
  ${CMAKE_SOURCE_DIR}/libs/lib/pkgconfig)
set(ENV{PKG_CONFIG_PATH_x86_64_w64_mingw32_shared}
  ${CMAKE_SOURCE_DIR}/libs/lib/pkgconfig)

execute_process(
  COMMAND brew --prefix qt5
  OUTPUT_VARIABLE QT_PREFIX_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE)

execute_process(
  COMMAND xcode-select -p
  OUTPUT_VARIABLE CMAKE_OSX_SYSROOT
  OUTPUT_STRIP_TRAILING_WHITESPACE)

set(CMAKE_OSX_DEPLOYMENT_TARGET 10.12)
set(CMAKE_OSX_SYSROOT
  ${CMAKE_OSX_SYSROOT}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${CMAKE_OSX_DEPLOYMENT_TARGET}.sdk)

project(qtox)
include(CTest)

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

# Use C++11.
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")

# Use ccache when available to speed up builds.
find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
  message(STATUS "using ccache")
endif()

# Search for headers in current directory.
include_directories(${CMAKE_BINARY_DIR})
include_directories(${CMAKE_SOURCE_DIR})

include(Dependencies)

################################################################################
#
# :: qTox main library sources
#
################################################################################

qt5_wrap_ui(${PROJECT_NAME}_FORMS
  src/chatlog/content/filetransferwidget.ui
  src/loginscreen.ui
  src/mainwindow.ui
  src/widget/about/aboutuser.ui
  src/widget/form/loadhistorydialog.ui
  src/widget/form/profileform.ui
  src/widget/form/removefrienddialog.ui
  src/widget/form/setpassworddialog.ui
  src/widget/form/settings/aboutsettings.ui
  src/widget/form/settings/advancedsettings.ui
  src/widget/form/settings/avform.ui
  src/widget/form/settings/generalsettings.ui
  src/widget/form/settings/privacysettings.ui
  src/widget/form/settings/userinterfacesettings.ui)

qt5_add_translation(${PROJECT_NAME}_QM_FILES
  translations/ar.ts
  translations/be.ts
  translations/bg.ts
  translations/cs.ts
  translations/da.ts
  translations/de.ts
  translations/el.ts
  translations/eo.ts
  translations/es.ts
  translations/et.ts
  translations/fi.ts
  translations/fr.ts
  translations/he.ts
  translations/hr.ts
  translations/hu.ts
  translations/it.ts
  translations/ja.ts
  translations/jbo.ts
  translations/ko.ts
  translations/lt.ts
  translations/nl.ts
  translations/no_nb.ts
  translations/pl.ts
  translations/pr.ts
  translations/pt.ts
  translations/ru.ts
  translations/sk.ts
  translations/sl.ts
  translations/sv.ts
  translations/sw.ts
  translations/tr.ts
  translations/ug.ts
  translations/uk.ts
  translations/zh_CN.ts
)

qt5_add_resources(
  ${PROJECT_NAME}_RESOURCES
  res.qrc
  ${CMAKE_CURRENT_BINARY_DIR}/translations.qrc
  DEPENDS ${${PROJECT_NAME}_QM_FILES}
)

if(NOT SMILEYS)
  set(SMILEYS "")
endif()

if(NOT "${SMILEYS}" STREQUAL "DISABLED")
  qt5_add_resources(
          ${PROJECT_NAME}_RESOURCES
          smileys/emojione.qrc)

  if(NOT "${SMILEYS}" STREQUAL "MIN")
    qt5_add_resources(
            ${PROJECT_NAME}_RESOURCES
            smileys/smileys.qrc)
  endif()

endif()

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/translations.qrc.in"
"<!DOCTYPE RCC>
<RCC version=\"1.0\">
  <qresource prefix=\"/translations\">
")
foreach(qm ${${PROJECT_NAME}_QM_FILES})
  get_filename_component(qm_name ${qm} NAME)
  file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/translations.qrc.in"
    "    <file alias=\"${qm_name}\">${qm}</file>\n")
endforeach(qm)
file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/translations.qrc.in"
"  </qresource>
</RCC>
")

execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different
  ${CMAKE_CURRENT_BINARY_DIR}/translations.qrc.in
  ${CMAKE_CURRENT_BINARY_DIR}/translations.qrc)

set(${PROJECT_NAME}_SOURCES
  src/audio/audio.cpp
  src/audio/audio.h
  src/chatlog/chatlinecontent.cpp
  src/chatlog/chatlinecontent.h
  src/chatlog/chatlinecontentproxy.cpp
  src/chatlog/chatlinecontentproxy.h
  src/chatlog/chatline.cpp
  src/chatlog/chatline.h
  src/chatlog/chatlog.cpp
  src/chatlog/chatlog.h
  src/chatlog/chatmessage.cpp
  src/chatlog/chatmessage.h
  src/chatlog/content/filetransferwidget.cpp
  src/chatlog/content/filetransferwidget.h
  src/chatlog/content/image.cpp
  src/chatlog/content/image.h
  src/chatlog/content/notificationicon.cpp
  src/chatlog/content/notificationicon.h
  src/chatlog/content/spinner.cpp
  src/chatlog/content/spinner.h
  src/chatlog/content/text.cpp
  src/chatlog/content/text.h
  src/chatlog/content/timestamp.cpp
  src/chatlog/content/timestamp.h
  src/chatlog/customtextdocument.cpp
  src/chatlog/customtextdocument.h
  src/chatlog/documentcache.cpp
  src/chatlog/documentcache.h
  src/chatlog/pixmapcache.cpp
  src/chatlog/pixmapcache.h
  src/core/coreav.cpp
  src/core/coreav.h
  src/core/core.cpp
  src/core/coredefines.h
  src/core/coreencryption.cpp
  src/core/corefile.cpp
  src/core/corefile.h
  src/core/core.h
  src/core/corestructs.cpp
  src/core/corestructs.h
  src/core/cstring.cpp
  src/core/cstring.h
  src/core/indexedlist.h
  src/core/recursivesignalblocker.cpp
  src/core/recursivesignalblocker.h
  src/core/toxcall.cpp
  src/core/toxcall.h
  src/core/toxencrypt.cpp
  src/core/toxencrypt.h
  src/core/toxid.cpp
  src/core/toxid.h
  src/core/toxpk.cpp
  src/core/toxpk.h
  src/friend.cpp
  src/friend.h
  src/friendlist.cpp
  src/friendlist.h
  src/group.cpp
  src/group.h
  src/grouplist.cpp
  src/grouplist.h
  src/ipc.cpp
  src/ipc.h
  src/net/autoupdate.cpp
  src/net/autoupdate.h
  src/net/avatarbroadcaster.cpp
  src/net/avatarbroadcaster.h
  src/net/toxme.cpp
  src/net/toxme.h
  src/net/toxuri.cpp
  src/net/toxuri.h
  src/nexus.cpp
  src/nexus.h
  src/persistence/db/encrypteddb.cpp
  src/persistence/db/encrypteddb.h
  src/persistence/db/genericddinterface.cpp
  src/persistence/db/genericddinterface.h
  src/persistence/db/plaindb.cpp
  src/persistence/db/plaindb.h
  src/persistence/db/rawdatabase.cpp
  src/persistence/db/rawdatabase.h
  src/persistence/history.cpp
  src/persistence/history.h
  src/persistence/historykeeper.cpp
  src/persistence/historykeeper.h
  src/persistence/offlinemsgengine.cpp
  src/persistence/offlinemsgengine.h
  src/persistence/profile.cpp
  src/persistence/profile.h
  src/persistence/profilelocker.cpp
  src/persistence/profilelocker.h
  src/persistence/serialize.cpp
  src/persistence/serialize.h
  src/persistence/settings.cpp
  src/persistence/settings.h
  src/persistence/settingsserializer.cpp
  src/persistence/settingsserializer.h
  src/persistence/smileypack.cpp
  src/persistence/smileypack.h
  src/persistence/toxsave.cpp
  src/persistence/toxsave.h
  src/platform/autorun.h
  src/platform/capslock.h
  src/platform/timer.h
  src/platform/autorun_osx.cpp
  src/platform/autorun_win.cpp
  src/platform/autorun_xdg.cpp
  src/platform/capslock_osx.cpp
  src/platform/capslock_win.cpp
  src/platform/capslock_x11.cpp
  src/platform/timer_osx.cpp
  src/platform/timer_win.cpp
  src/platform/timer_x11.cpp
  src/video/cameradevice.cpp
  src/video/cameradevice.h
  src/video/camerasource.cpp
  src/video/camerasource.h
  src/video/corevideosource.cpp
  src/video/corevideosource.h
  src/video/genericnetcamview.cpp
  src/video/genericnetcamview.h
  src/video/groupnetcamview.cpp
  src/video/groupnetcamview.h
  src/video/netcamview.cpp
  src/video/netcamview.h
  src/video/videoframe.cpp
  src/video/videoframe.h
  src/video/videomode.cpp
  src/video/videomode.h
  src/video/videosource.cpp
  src/video/videosource.h
  src/video/videosurface.cpp
  src/video/videosurface.h
  src/widget/about/aboutuser.cpp
  src/widget/about/aboutuser.h
  src/widget/categorywidget.cpp
  src/widget/categorywidget.h
  src/widget/circlewidget.cpp
  src/widget/circlewidget.h
  src/widget/contentdialog.cpp
  src/widget/contentdialog.h
  src/widget/contentlayout.cpp
  src/widget/contentlayout.h
  src/widget/emoticonswidget.cpp
  src/widget/emoticonswidget.h
  src/widget/flowlayout.cpp
  src/widget/flowlayout.h
  src/widget/form/addfriendform.cpp
  src/widget/form/addfriendform.h
  src/widget/form/chatform.cpp
  src/widget/form/chatform.h
  src/widget/form/filesform.cpp
  src/widget/form/filesform.h
  src/widget/form/genericchatform.cpp
  src/widget/form/genericchatform.h
  src/widget/form/groupchatform.cpp
  src/widget/form/groupchatform.h
  src/widget/form/groupinviteform.cpp
  src/widget/form/groupinviteform.h
  src/widget/form/loadhistorydialog.cpp
  src/widget/form/loadhistorydialog.h
  src/widget/form/profileform.cpp
  src/widget/form/profileform.h
  src/widget/form/setpassworddialog.cpp
  src/widget/form/setpassworddialog.h
  src/widget/form/settings/aboutform.cpp
  src/widget/form/settings/aboutform.h
  src/widget/form/settings/advancedform.cpp
  src/widget/form/settings/advancedform.h
  src/widget/form/settings/avform.cpp
  src/widget/form/settings/avform.h
  src/widget/form/settings/generalform.cpp
  src/widget/form/settings/generalform.h
  src/widget/form/settings/genericsettings.cpp
  src/widget/form/settings/genericsettings.h
  src/widget/form/settings/privacyform.cpp
  src/widget/form/settings/privacyform.h
  src/widget/form/settings/userinterfaceform.h
  src/widget/form/settings/userinterfaceform.cpp
  src/widget/form/settings/verticalonlyscroller.cpp
  src/widget/form/settings/verticalonlyscroller.h
  src/widget/form/settingswidget.cpp
  src/widget/form/settingswidget.h
  src/widget/form/tabcompleter.cpp
  src/widget/form/tabcompleter.h
  src/widget/friendlistlayout.cpp
  src/widget/friendlistlayout.h
  src/widget/friendlistwidget.cpp
  src/widget/friendlistwidget.h
  src/widget/friendwidget.cpp
  src/widget/friendwidget.h
  src/widget/genericchatitemlayout.cpp
  src/widget/genericchatitemlayout.h
  src/widget/genericchatitemwidget.cpp
  src/widget/genericchatitemwidget.h
  src/widget/genericchatroomwidget.cpp
  src/widget/genericchatroomwidget.h
  src/widget/groupwidget.cpp
  src/widget/groupwidget.h
  src/widget/gui.cpp
  src/widget/gui.h
  src/widget/loginscreen.cpp
  src/widget/loginscreen.h
  src/widget/maskablepixmapwidget.cpp
  src/widget/maskablepixmapwidget.h
  src/widget/notificationedgewidget.cpp
  src/widget/notificationedgewidget.h
  src/widget/notificationscrollarea.cpp
  src/widget/notificationscrollarea.h
  src/widget/passwordedit.cpp
  src/widget/passwordedit.h
  src/widget/qrwidget.cpp
  src/widget/qrwidget.h
  src/widget/style.cpp
  src/widget/style.h
  src/widget/systemtrayicon.cpp
  src/widget/systemtrayicon.h
  src/widget/systemtrayicon_private.h
  src/widget/tool/activatedialog.cpp
  src/widget/tool/activatedialog.h
  src/widget/tool/adjustingscrollarea.cpp
  src/widget/tool/adjustingscrollarea.h
  src/widget/tool/callconfirmwidget.cpp
  src/widget/tool/callconfirmwidget.h
  src/widget/tool/chattextedit.cpp
  src/widget/tool/chattextedit.h
  src/widget/tool/croppinglabel.cpp
  src/widget/tool/croppinglabel.h
  src/widget/tool/flyoutoverlaywidget.cpp
  src/widget/tool/flyoutoverlaywidget.h
  src/widget/tool/friendrequestdialog.cpp
  src/widget/tool/friendrequestdialog.h
  src/widget/tool/micfeedbackwidget.cpp
  src/widget/tool/micfeedbackwidget.h
  src/widget/tool/movablewidget.cpp
  src/widget/tool/movablewidget.h
  src/widget/tool/profileimporter.cpp
  src/widget/tool/profileimporter.h
  src/widget/tool/removefrienddialog.cpp
  src/widget/tool/removefrienddialog.h
  src/widget/tool/screengrabberchooserrectitem.cpp
  src/widget/tool/screengrabberchooserrectitem.h
  src/widget/tool/screengrabberoverlayitem.cpp
  src/widget/tool/screengrabberoverlayitem.h
  src/widget/tool/screenshotgrabber.cpp
  src/widget/tool/screenshotgrabber.h
  src/widget/tool/toolboxgraphicsitem.cpp
  src/widget/tool/toolboxgraphicsitem.h
  src/widget/translator.cpp
  src/widget/translator.h
  src/widget/widget.cpp
  src/widget/widget.h
)

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  set(${PROJECT_NAME}_SOURCES ${${PROJECT_NAME}_SOURCES}
    src/platform/camera/directshow.cpp
    src/platform/camera/directshow.h
  )
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(${PROJECT_NAME}_SOURCES ${${PROJECT_NAME}_SOURCES}
    src/platform/camera/v4l2.cpp
    src/platform/camera/v4l2.h
  )
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(${PROJECT_NAME}_SOURCES ${${PROJECT_NAME}_SOURCES}
    src/platform/install_osx.cpp
    src/platform/install_osx.h
  )
endif()

add_definitions(-DQT_MESSAGELOGCONTEXT=1)

if (NOT ENABLE_STATUSNOTIFIER)
  set(ENABLE_STATUSNOTIFIER True)
endif()

if(${ENABLE_STATUSNOTIFIER} AND GDK_PIXBUF_FOUND AND GLIB_FOUND AND GTK_FOUND)
  set(${PROJECT_NAME}_SOURCES ${${PROJECT_NAME}_SOURCES}
    src/platform/statusnotifier/closures.c
    src/platform/statusnotifier/closures.h
    src/platform/statusnotifier/enums.c
    src/platform/statusnotifier/enums.h
    src/platform/statusnotifier/interfaces.h
    src/platform/statusnotifier/statusnotifier.c
    src/platform/statusnotifier/statusnotifier.h)
  add_definitions(-DENABLE_SYSTRAY_STATUSNOTIFIER_BACKEND=1)
endif()

if(AVFOUNDATION_FOUND)
  set(${PROJECT_NAME}_SOURCES ${${PROJECT_NAME}_SOURCES}
    src/platform/camera/avfoundation.mm
    src/platform/camera/avfoundation.h)
endif()

if (NOT ENABLE_APPINDICATOR)
  set(ENABLE_APPINDICATOR False)
endif()
if(${ENABLE_APPINDICATOR} AND APPINDICATOR_FOUND)
  add_definitions(-DENABLE_SYSTRAY_UNITY_BACKEND=1)
endif()

if (NOT ENABLE_GTK_SYSTRAY)
  set(ENABLE_GTK_SYSTRAY True)
endif()

if(${ENABLE_GTK_SYSTRAY} AND GTK_FOUND)
  add_definitions(-DENABLE_SYSTRAY_GTK_BACKEND=1)
endif()

add_library(${PROJECT_NAME}_static
  STATIC
  ${${PROJECT_NAME}_FORMS}
  ${${PROJECT_NAME}_SOURCES}
  ${${PROJECT_NAME}_QM_FILES})
target_link_libraries(${PROJECT_NAME}_static
  ${ALL_LIBRARIES})

add_executable(${PROJECT_NAME}
  WIN32
  MACOSX_BUNDLE
  ${${PROJECT_NAME}_RESOURCES}
  src/main.cpp)
target_link_libraries(${PROJECT_NAME}
  ${PROJECT_NAME}_static
  ${ALL_LIBRARIES})

################################################################################
#
# :: Tests
#
################################################################################

function(auto_test subsystem module)
  add_executable(${module}_test
    test/${subsystem}/${module}_test.cpp)
  target_link_libraries(${module}_test
    ${PROJECT_NAME}_static
    ${ALL_LIBRARIES}
    Qt5::Test)
  add_test(
    NAME test_${module}
    COMMAND ${module}_test)
endfunction()

include(Installation)