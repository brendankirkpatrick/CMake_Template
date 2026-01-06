# Enable sanitizers
set(SANITIZERS "")
if(${PROJ_NAME}_ENABLE_SANITIZER_ADDRESS)
    list(APPEND SANITIZERS "address")
endif()

if(${PROJ_NAME}_ENABLE_SANITIZER_LEAK)
    list(APPEND SANITIZERS "leak")
endif()

if(${PROJ_NAME}_ENABLE_SANITIZER_UNDEFINED_BEHAVIOR)
    list(APPEND SANITIZERS "undefined")
endif()

if(${PROJ_NAME}_ENABLE_SANITIZER_THREAD)
    if("address" IN_LIST SANITIZERS OR "leak" IN_LIST SANITIZERS)
        message(WARNING "Thread sanitizer does not work with Address and Leak sanitizer enabled")
    else()
        list(APPEND SANITIZERS "thread")
    endif()
endif()

if(${PROJ_NAME}_ENABLE_SANITIZER_MEMORY AND CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    message(
    WARNING
      "Memory sanitizer requires all the code (including libc++) to be MSan-instrumented otherwise it reports false positives"
  )
    if("address" IN_LIST SANITIZERS
     OR "thread" IN_LIST SANITIZERS
     OR "leak" IN_LIST SANITIZERS)
        message(WARNING "Memory sanitizer does not work with Address, Thread or Leak sanitizer enabled")
    else()
        list(APPEND SANITIZERS "memory")
    endif()
endif()

list( JOIN
      SANITIZERS
      ","
      LIST_OF_SANITIZERS)

if(LIST_OF_SANITIZERS)
    if(NOT
       "${LIST_OF_SANITIZERS}"
       STREQUAL
       "")
        # Apparently MSVC is weird so just disable for now
        if(NOT MSVC)
            target_compile_options(${PROJECT_NAME}_settings INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
            target_link_options(${PROJECT_NAME}_settings INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
        endif()
    endif()
endif()
