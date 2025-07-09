import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12



Rectangle{
    id:atpfooter_1
    width:parent.width
    height: parent.height*0.06
    color: "#333333"
    clip: true

    Label{
        anchors.right: atpfooter_1.right
        anchors.verticalCenter: atpfooter_1.verticalCenter
        anchors.rightMargin: 0.02*atpfooter_1.width
        font.family: sourceNotoFont.name
        text: "\u00a9 2024-2025 FieldMod GuoLiang Tan"

    }


}



