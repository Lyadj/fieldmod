import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14


ComboBox{
    id:gripper_combo_3

    property string defaultname: "请选择指令"
    property string whitecolor: "white"
    property string ambercolor: "#FFBF00"
    property string currentHexString: "00 FF"

    valueRole: "hexCommandString"
    textRole: "commandName"



    contentItem: Text {
        id:display_text
        leftPadding: 0.1*parent.width
        text: gripper_combo_3.displayText
        color:whitecolor
        font.pixelSize: 16
        font.family: sourceNotoFont.name
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }


    delegate: ItemDelegate {
        width: gripper_combo_3.width
        height: gripper_combo_3.height*0.8
        contentItem: Text {
            text: model.commandName
            color: highlightedIndex === index?ambercolor:whitecolor
            font.pixelSize: 16
            font.family: sourceNotoFont.name
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
//        onClicked: {
//            selectserialport(model.index)
//        }
    }


//    function selectserialport(index){
//        var eachSerialPort = gripper_combo_3.model.get(index)
////        display_text.text = eachSerialPort.commandName
//            gripper_combo_3.currentHexString = eachSerialPort.hexCommandString
//    }


}

