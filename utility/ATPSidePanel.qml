import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.14

Item{
    id:sidebar
    width:0.07*parent.width
    height: parent.height+2*vgap
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.topMargin: -2*vgap


    property int animation_time: 300
    property int animation_time_200: 200


    property real vgap: 0.01*parent.height
    property real hgap: 0.01*parent.width

    property real sidebar_min_width: parent.width*0.1
    property real sidebar_max_width: parent.width*0.2

    property real sidebar_min_height: parent.height*0.1
    property real sidebar_max_height: parent.height*0.2

    property bool sidebar_expanded_status: false
    property bool lock_btn_status: false

    property string lock_color: "#FF5722"
    property string unlock_color: "transparent"


    signal switch_tools_signal(var toolname)

    //切换目标的控制组件
    signal atp_active_component(var toolname)

    clip: true

    states:[
        State{
            name:"expanded"
            PropertyChanges {
                target: sidebar
                width:0.15*parent.width
            }

        },
        State {
            name: "collapsed"
            PropertyChanges {
                target: sidebar
                width:0.07*parent.width
            }
        }
    ]

    state: "collapsed"

    transitions: [
        Transition {
            from: "collapsed"
            to: "expanded"
            NumberAnimation{
                properties: "width"
                duration: animation_time
                easing.type: Easing.OutCubic
            }
        },
        Transition {
            from: "expanded"
            to: "collapsed"
            NumberAnimation{
                properties: "width"
                duration: animation_time*2.5
                easing.type: Easing.OutCubic
            }
        }
    ]

    Rectangle{
        id:sidebar_content
        anchors.fill: parent
        color: "#454545"


        ColumnLayout{
            id: toolsbtnlayout

            width: parent.width
            spacing: 2*vgap
            anchors { top: parent.top; topMargin: 4*vgap }

            Repeater{
                id:toolsrepeaer

                model:[ {key:"gripper",value:"机械电爪"},
                        {key:"syringe",value:"注射泵"},
                        {key:"balance_scale",value:"精密天平"},
                        {key:"cable",value:"通信工具"},
                        {key:"log",value:"操作记录"},
                        {key:"settings",value:"系统设置"}]

                delegate: Rectangle{
                    id:eachbutton
                    Layout.preferredWidth: 4*hgap
                    Layout.preferredHeight: vgap*10
                    radius: vgap
                    color: buttonMouseArea.containsMouse ? lock_color : unlock_color
                    Layout.alignment: Qt.AlignLeft


                    Behavior on color {
                        ColorAnimation {
                            duration: animation_time_200
                        }
                    }

                    state:"hidetitle"

                    states: [
                        State {
                            name: 'showtitle'
                            PropertyChanges {
                                target: eachbutton
                                Layout.leftMargin: hgap
                                Layout.preferredWidth:  12*hgap
                            }

                            PropertyChanges {
                                target: btntitle
                                opacity: 1
                            }
                        },
                        State {
                            name: 'hidetitle'
                            PropertyChanges {
                                target: eachbutton
                                Layout.leftMargin: hgap
                                Layout.preferredWidth: 5*hgap
                            }

                            PropertyChanges {
                                target: btntitle
                                opacity: 0
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            from: "showtitle"
                            to: "hidetitle"
                            NumberAnimation{
                                properties: "Layout.preferredWidth,opacity"
                                duration: animation_time
                                easing.type: Easing.InOutSine

                            }
                        },
                        Transition {
                            from: "hidetitle"
                            to: "showtitle"
                            NumberAnimation{
                                properties: "Layout.preferredWidth,opacity"
                                duration: animation_time_200
                                easing.type: Easing.InOutSine
                            }
                        }
                    ]


                    MouseArea {
                        id: buttonMouseArea

                        hoverEnabled: true
                        anchors.fill: parent


                        onEntered: {

                        }

                        onClicked: {
                            handle_click_tool(model.index,modelData.value)
                        }

                    }


                    Image {
                        id: btnicon
                        source: 'qrc:/resources/' + modelData.key + '.svg'
                        width: 4*hgap
                        anchors { verticalCenter: parent.verticalCenter; left: parent.left;leftMargin: 0.5*hgap}
                    }

                    Text {
                        id: btntitle
                        text: modelData.value
                        color: "white"
                        anchors { verticalCenter: parent.verticalCenter; left: btnicon.right;}
                        font.family: sourceNotoFont.name
                    }



                }

            }



        }

    }


    DropShadow{
        id:sidebarshadow
        source: sidebar_content
        radius: 2*hgap
        samples: radius*2+1
        color: Qt.rgba(0,0,0,0.05)
    }

    Timer{
        id:resettime
        interval: 800
        repeat: false
        onTriggered: {

            restore_sidebar()
        }
    }

    function handle_click_tool(index,titlename){

        if(lock_btn_status){
            return
        }

        sidebar_expanded_status = true

        for(var i=0;i<toolsrepeaer.count;++i){

            if(sidebar_expanded_status && i == index){
                toolsrepeaer.itemAt(i).state="showtitle"
            }
        }

        sidebar.state = sidebar_expanded_status ? "expanded":"collapsed"
        lock_btn_status = true

        appheader.change_tool_title(titlename)

        switch_tools_signal(titlename)

        resettime.start();
    }


    function restore_sidebar(){

        //重置扩展状态
        sidebar_expanded_status = false
        sidebar.state = "collapsed"

        //重置所有按钮的状态
        for(var i=0;i<toolsrepeaer.count;++i){
            toolsrepeaer.itemAt(i).state="hidetitle"
        }


        lock_btn_status=false
    }




}
