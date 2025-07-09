import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14


ComboBox{
    id:gripper_combo_1

    property string defaultserialname: "选择串口"
    property string whitecolor: "white"
    property string ambercolor: "#FFBF00"

    property string serialname: ""

    ListModel {
        id: comboBoxModel
    }

    contentItem: Text {
        id:display_text
        leftPadding: 0.1*parent.width
        text: gripper_combo_1.displayText
        color:whitecolor
        font.pixelSize: 16
        font.family: sourceNotoFont.name
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    model: comboBoxModel


    delegate: ItemDelegate {
        width: gripper_combo_1.width
        height: gripper_combo_1.height*0.8
        contentItem: Text {
            text: model.displayText
            color: highlightedIndex === index?ambercolor:whitecolor
            font.pixelSize: 16
            font.family: sourceNotoFont.name
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            selectserialport(model.index)
        }
    }



    function addSerialPort(list) {

        comboBoxModel.clear()
        for(var i=0;i<list.length;++i){
            comboBoxModel.append({index:i,displayText:list[i],selected:false})
        }
        gripper_combo_1.displayText = defaultserialname
    }

    function selectserialport(index){

        for(var i=0;i<comboBoxModel.count;++i){

            var eachSerialPort = comboBoxModel.get(i)
            if(index == i){
                display_text.text = eachSerialPort.displayText
                gripper_combo_1.displayText = eachSerialPort.displayText
            }

        }
    }



}
