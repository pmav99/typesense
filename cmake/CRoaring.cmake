# Download and build H2O

set(ROARING_VERSION 0.2.17)
set(ROARING_NAME CRoaring-${ROARING_VERSION})
set(ROARING_TAR_PATH ${CMAKE_SOURCE_DIR}/external/${ROARING_NAME}.tar.gz)

if(NOT EXISTS ${CMAKE_SOURCE_DIR}/external/${ROARING_NAME})
    if(NOT EXISTS ${ROARING_TAR_PATH})
        message(STATUS "Downloading ${ROARING_NAME}...")
        file(DOWNLOAD https://github.com/RoaringBitmap/CRoaring/archive/v${ROARING_VERSION}.tar.gz ${ROARING_TAR_PATH})
    endif()
    message(STATUS "Extracting ${ROARING_NAME}...")
    execute_process(COMMAND ${CMAKE_COMMAND} -E tar xvzf ${ROARING_TAR_PATH} WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/external/)
endif()

if(NOT EXISTS ${CMAKE_SOURCE_DIR}/external/${ROARING_NAME}/build)
    message("Configuring ${ROARING_NAME}...")
    file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/external/${ROARING_NAME}/build)
    execute_process(COMMAND ${CMAKE_COMMAND}
            "-H${CMAKE_SOURCE_DIR}/external/${ROARING_NAME}"
            "-B${CMAKE_SOURCE_DIR}/external/${ROARING_NAME}/build"
            RESULT_VARIABLE
            ROARING_CONFIGURE)
    if(NOT ROARING_CONFIGURE EQUAL 0)
        message(FATAL_ERROR "${ROARING_NAME} configure failed!")
    endif()

    message("Building ${ROARING_NAME} locally...")
    execute_process(COMMAND ${CMAKE_COMMAND} --build
            "${CMAKE_SOURCE_DIR}/external/${ROARING_NAME}/build"
            RESULT_VARIABLE
            ROARING_BUILD)
    if(NOT ROARING_BUILD EQUAL 0)
        message(FATAL_ERROR "${ROARING_NAME} build failed!")
    endif()
endif()