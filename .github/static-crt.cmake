# Passed to the Windows configure with -DCMAKE_PROJECT_INCLUDE; CMake runs it
# after every project() call. The shaderc that vulkan-video-samples fetches sets
# the DLL runtime for its own directory, overriding CMAKE_MSVC_RUNTIME_LIBRARY.
# At the end of configure, put its targets back on the runtime the build asked for.
get_property(_static_crt_hooked GLOBAL PROPERTY STATIC_CRT_HOOKED)
if (NOT _static_crt_hooked)
    set_property(GLOBAL PROPERTY STATIC_CRT_HOOKED TRUE)
    function(_static_crt_fix_shaderc)
        foreach (t shaderc shaderc_util shaderc_combined shaderc_shared glslc glslc_exe)
            if (TARGET ${t})
                set_property(TARGET ${t} PROPERTY MSVC_RUNTIME_LIBRARY "${CMAKE_MSVC_RUNTIME_LIBRARY}")
            endif ()
        endforeach ()
    endfunction()
    cmake_language(DEFER DIRECTORY "${CMAKE_SOURCE_DIR}" CALL _static_crt_fix_shaderc)
endif ()
