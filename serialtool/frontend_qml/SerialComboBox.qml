import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14


ComboBox{
    id:serial_info_combo_1

    property string defaultname: "请选择"
    property string whitecolor: "white"
    property string ambercolor: "#FFBF00"

    contentItem: Text {
        id:display_text
        leftPadding: 0.1*parent.width
        text: serial_info_combo_1.displayText
        color:whitecolor
        font.pixelSize: 16
        font.family: sourceNotoFont.name
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }


    delegate: ItemDelegate {
        width: serial_info_combo_1.width
        height: serial_info_combo_1.height*0.8
        contentItem: Text {
            text: modelData
            color: highlightedIndex === index?ambercolor:whitecolor
            font.pixelSize: 16
            font.family: sourceNotoFont.name
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

}
