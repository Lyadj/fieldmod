import QtQuick 2.14
import QtQuick.Controls 2.14
import "../gripper/frontend_qml/"
import "../serialtool/frontend_qml/"
import "../balance/frontend_qml/"
import "../syringe/frontend_qml/"
import "./"

StackView{
    id:toolstackview
    height: parent.height
    width:parent.width - navi_bar.width
    anchors.top: parent.top
    anchors.left: navi_bar.right

    initialItem: home_page
    clip: true

    property var titleVector: ["主页","机械电爪","注射泵","精密天平","通信工具","操作记录","系统设置"]
    property var viewVector: [home_page,gripper_page,syringe_page,balance_page,serial_page,log_page,settings_page]

    property int current_selected_index: 99

    ATPHomePage{
        id:home_page
    }

    GripperMainView{
        id:gripper_page
        visible: false
    }

    ATPSyringe{
        id:syringe_page
        visible: false
    }


    BalanceScale{
        id:balance_page
        visible: false
    }


    SerialTerminal{
        id:serial_page
        visible: false
    }

    ATPLog{
        id:log_page
        objectName: "logview"
        visible: false
    }

    ATPSettings{
        id:settings_page
        visible: false
    }


    //设置动画
    pushEnter: Transition {
        PropertyAnimation{
            property:"x"
            from:toolstackview.x + toolstackview.width
            to:toolstackview.x - navi_bar.width
            duration: 400
        }
    }

    pushExit: Transition {
        PropertyAnimation{
            property:"x"
            from:toolstackview.x - navi_bar.width
            to:toolstackview.x - toolstackview.width
            duration: 400
        }
    }




    function handle_stackview_change(titlename){

        var activate_index = titleVector.indexOf(titlename)

        if(activate_index == current_selected_index){
            return
        }

        toolstackview.replace(viewVector[activate_index],StackView.PushTransition)

        current_selected_index = activate_index
    }


}
