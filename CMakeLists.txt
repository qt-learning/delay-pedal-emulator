cmake_minimum_required(VERSION 3.16)

project(DelayPedalEmulation VERSION 0.1 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(DelayPedalEmulation
    main.cpp
)

qt_add_qml_module(DelayPedalEmulation
    URI app
    QML_FILES Main.qml
    RESOURCES
        assets/button.png
        assets/button_pressed.png
        assets/knob.png
        assets/oldsteel.png
        assets/on_off_led.png
        assets/screw.png
        assets/switch.png
        fonts/Prisma.ttf
        fonts/RussoOne-Regular.ttf
)

target_link_libraries(DelayPedalEmulation
    PRIVATE Qt6::Quick)

install(TARGETS DelayPedalEmulation
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
