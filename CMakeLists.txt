CMAKE_MINIMUM_REQUIRED ( VERSION 3.5 )

project(BoostStatechartVisualizer)


find_package(LLVM REQUIRED CONFIG)
find_package(CLANG REQUIRED CONFIG)

set (CMAKE_CXX_STANDARD 17)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# Set your project compile flags.
# E.g. if using the C++ header files
# you will need to enable C++11 support
# for your compiler.

message(STATUS "LLVM include dirs ${LLVM_INCLUDE_DIRS}")
message(STATUS "LLVM definitions ${LLVM_DEFINITIONS}")
message(STATUS "LLVM library dirs ${LLVM_LIBRARY_DIRS}")

include_directories(${LLVM_INCLUDE_DIRS} ${CLANG_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})

#execute_process(COMMAND llvm-config --libs all OUTPUT_VARIABLE llvm_libraries)

#message(STATUS "LLVM libraries ${LLVM_LIBRARIES}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${LLVM_CMAKE_CXX_FLAGS}")


# Find the libraries that correspond to the LLVM components that we wish to use
# llvm_map_components_to_libnames(llvm_libs )
# message(STATUS "LLVM libs ${llvm_libs}")

add_library(visualizer SHARED src/visualizer.cpp)

# Link against LLVM libraries
target_link_libraries(visualizer clangBasic clangAST clangASTMatchers clangFrontend)

