import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12



Rectangle{
    id:atpheader_1
    width:parent.width
    height: parent.height*0.07
    color: "#660066"

    property bool expand_status: false

    property int animation_time: 400

    property string tooltile: ""

    RectangularGlow{
        id:header_glow
        anchors.fill: parent
        glowRadius: parent.height*0.2
        spread: 0.1
        color: "white"
        cornerRadius: header_background.radius+glowRadius
    }

    Rectangle{
        id:header_background
        width: parent.width
        height:parent.height*1.0
        radius: parent.height*0.1
        color:"#660066"
    }


    Label{
        id:tooltitle_label
        text: tooltile
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 20
        font.family: sourceNotoFont.name
        Behavior on text {
            NumberAnimation{
                target: tooltitle_label
                properties: "opacity"
                duration: 400
                from:0
                to:1
            }
        }
    }


    function change_tool_title(titlename){
        tooltile = titlename
    }


}



