cmake_minimum_required(VERSION 3.14)

project(SuperTest)

set(PRJ $ENV{PROJECT_DIRECTORY})
set(TESTS_DIR $ENV{TESTS_DIRECTORY})
message(WARNING ${PRJ})

# add_compile_options(-Werror)

add_subdirectory(${PRJ})

include_directories(${PRJ}/prj.lab)

add_executable(__rational_test ${TESTS_DIR}/rational_test.cpp)
target_link_libraries(__rational_test rational)

enable_testing()
add_test(RationalTest __rational_test "")
