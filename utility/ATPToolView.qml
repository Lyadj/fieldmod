import QtQuick 2.14
import QtQuick.Controls 2.14
import "./"

Item{
    id:appview_1

    ATPSidePanel{
        id:navi_bar
        onSwitch_tools_signal: {
            instanceview.handle_stackview_change(toolname)
        }
    }

    ATPStackView{
        id:instanceview

    }

    ATPPopNotice{
        id:notice_popup
        x:instanceview.x
        y:instanceview.y+instanceview.height*0.9
        width: instanceview.width
        height: instanceview.height*0.1
    }



}


