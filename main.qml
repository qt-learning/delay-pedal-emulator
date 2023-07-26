import QtQuick

Window {
    id: root
    width: 260
    height: 380
    visible: true

    FontLoader {
        id: russo
        source: "fonts/RussoOne-Regular.ttf"
    }

    FontLoader {
        id: prisma
        source: "fonts/Prisma.ttf"
    }

    Rectangle {
        id: mainFrame
        anchors.fill: root.contentItem
        property bool standBy: true

        // Texture
        Image {
            source: "assets/oldsteel.png"
            anchors.fill: mainFrame
            opacity: 0.4
        }


        gradient: Gradient {
        //    GradientStop {position: 0.0; color: "#002002" }
        //    GradientStop {position: 1.0; color: "#002002" }
            GradientStop {position: 0.0; color: "#cccccc" }
            GradientStop {position: 1.0; color: "#efefef" }
            // GradientStop {position: 0.0; color: "#181818" }
            // GradientStop {position: 1.0; color: "#161616" }
        }

        // topleft screw
        Image {
            id: tls
            source: "assets/screw.png"
            anchors { left:mainFrame.left; top:mainFrame.top}
            height: 24; width:24
        }

        // topright screw
        Image {
            source: "assets/screw.png"
            anchors { right:mainFrame.right; top:mainFrame.top}
            height: 24; width:24
        }

        // bottomleft screw
        Image {
            source: "assets/screw.png"
            anchors { left:mainFrame.left; bottom:mainFrame.bottom}
            height: 24; width:24
        }

        // bottomright screw
        Image {
            source: "assets/screw.png"
            anchors { right:mainFrame.right; bottom:mainFrame.bottom}
            height: 24; width:24
        }

        // Customized text for
        component DeviceText: Text {
            color: "#191919"
            font.family: russo.font.family
            font.weight: russo.font.weight
            font.pixelSize: 9
        }

        // Customized text for labels
        component InfoText: Column {
            id: infoLabel
            property alias text: label.text
            property alias font: label.font
            property int lineWidth: 200
            property int lineHeight: 2
            property color lineColor: "#191919"

            Rectangle {
                width: infoLabel.lineWidth
                height: infoLabel.lineHeight
                color: infoLabel.lineColor
            }

            DeviceText {
                id: label
                anchors.horizontalCenter: infoLabel.horizontalCenter
            }

            Rectangle {
                width: infoLabel.lineWidth
                height: infoLabel.lineHeight
                color: infoLabel.lineColor
            }
        }

        // Knobs
        component SpriteImage64: Image {
                id: knob
                source: "assets/knob.png"
                sourceClipRect: Qt.rect(0,(imageIndex * frameLength), frameLength, frameLength)

                property alias text: knobFunction.text
                property int imageIndex
                property real frameLength: knob.width

                // value that knobs currently holding
                // min:0, max:100
                property int value: 0

                // Map from png index to value
                function valueFromPngIndex(value: int) : int {
                    return Math.round(100 * value / 99);
                }

                // limiter
                function clamp(minValue: int, maxValue:int, value: int) : int{
                    return Math.max(minValue, Math.min(maxValue, value));
                }


                MouseArea {
                    id: mouseArea
                    anchors.fill: knob
                    acceptedButtons: Qt.LeftButton
                    preventStealing: true
                    property int clickOffset: 0
                    property int lastInc: 0
                    property int step: 2

                    // Register the first touch point
                    onPressed: (mouse)=>{
                             clickOffset =  mouse.y
                     }

                     // Update the knob value when released
                     onReleased: {
                         clickOffset = 0;
                         lastInc = 0;

                     }

                     // Value update logic
                     //
                     onPositionChanged: (mouse)=>{
                        if (pressed) {
                            const delta  = Math.round((clickOffset - mouse.y) / step);
                            if (lastInc != delta) {
                                knob.imageIndex = clamp(0, 99, knob.imageIndex + delta - lastInc);
                                lastInc = delta;
                                knob.value = valueFromPngIndex(knob.imageIndex);
                            }

                            console.info("Value :", knob.value);
                        }
                     }

                     // Default state
                     onDoubleClicked: {
                        knob.imageIndex = 0;
                        knob.value = 0;
                     }
                }

                DeviceText {
                    id: knobFunction
                    anchors.top: knob.bottom
                    anchors.horizontalCenter: knob.horizontalCenter
                }

                DeviceText {
                    text: "MIN"
                    anchors.left: knob.left
                    anchors.bottom: knob.bottom
                    font.pixelSize: 6
                }

                DeviceText {
                    text: "MAX"
                    anchors.right: knob.right
                    anchors.bottom: knob.bottom
                    font.pixelSize: 6
                }
            }
        }

        // Standby/On LED
        Column {
            id: standbyOn
            anchors.top: mainFrame.top
            anchors.right: levelKnob.left
            anchors.rightMargin: 10
            spacing: -2

            Image {
                id: standByOnLed
                z:1
                source: "assets/on_off_led.png"
                sourceSize.width: 24
                sourceClipRect: Qt.rect(0, mainFrame.standBy ? 0 : 24, 24, 24)

            }

            DeviceText {
                text: "CHECK"
                font.pixelSize: 8
                font.weight: Font.Medium
                anchors.horizontalCenter: standbyOn.horizontalCenter
            }
        }

        // Level Control
        SpriteImage64 {
            id: levelKnob
            anchors.horizontalCenter: mainFrame.horizontalCenter
            anchors.top: mainFrame.top
            anchors.topMargin: 10
            text: "LEVEL"
        }

        // Mode switch
        Column {
            id: column
            anchors.left: levelKnob.right
            anchors.bottom: standbyOn.bottom
            anchors.leftMargin: 10
            spacing: -2

            Image {
                id: mode
                source: "assets/switch.png"
                sourceSize: "24x48"
                sourceClipRect: Qt.rect(0, mode.on ? 24 : 0, 24, 24)
                property bool on: false

                MouseArea {
                    anchors.fill: mode
                    onClicked: mode.on = !mode.on
                }
            }

            DeviceText {
                text: "MODE"
                font.pixelSize: 8
                font.weight: Font.Medium
                anchors.horizontalCenter: column.horizontalCenter
            }
        }

        // Time Control
        SpriteImage64 {
            id: timeKnob
            anchors.left: mainFrame.left
            anchors.top: levelKnob.bottom
            anchors.topMargin: 30
            anchors.leftMargin: 30
            text: "TIME"
        }

        // Feedback Control
        SpriteImage64 {
            id: fbKnob
            anchors.right: mainFrame.right
            anchors.top: levelKnob.bottom
            anchors.topMargin: 30
            anchors.rightMargin: 30
            text: "FEEDBACK"
        }

        // Brand Label
        InfoText {
            id: brand
            spacing: 10
            anchors.top: fbKnob.bottom
            anchors.horizontalCenter: mainFrame.horizontalCenter
            anchors.topMargin: 30
            text: "TIME BLENDER"
            font.family: prisma.font.family
            font.pixelSize: 18
        }

        // Input Label
        InfoText {
            id: inputLabel
            spacing: 5
            anchors.top: mainFrame.top
            anchors.right: mainFrame.right
            anchors.topMargin: 60
            text: "IN"
            lineWidth: 30
            lineHeight:2
        }

        // Output label
        InfoText {
            id: outputLabel
            spacing: 5
            anchors.top: mainFrame.top
            anchors.left: mainFrame.left
            anchors.topMargin: 60
            text: "OUT"
            lineWidth: 30
            lineHeight:2
        }

        // Foot switch
        Image {
            id: footSwitch
            source: mainFrame.standBy ? "assets/button.png" : "assets/button_pressed.png"
            anchors.bottom: mainFrame.bottom
            anchors.horizontalCenter: mainFrame.horizontalCenter
            sourceSize {width: 110; height:110}
            MouseArea {
                anchors.fill: footSwitch

                onClicked: mainFrame.standBy = !mainFrame.standBy
            }
        }

        // We dont need to use bindings because we don't want to reevaluate
        // these properties.
        Component.onCompleted: ()=>{
            root.minimumWidth = root.width;
            root.minimumHeight = root.height;
            root.maximumWidth = root.minimumWidth;
            root.maximumHeight = root.minimumHeight;
        }
}


// Credits
// MetalTexture: Image by kjpargeter on freepik "https://www.freepik.com/free-photo/grunge-wall-texture_988115.htm"
// Knobs ans Switch: Public Domain https://www.g200kg.com/en/webknobman/gallery.php
