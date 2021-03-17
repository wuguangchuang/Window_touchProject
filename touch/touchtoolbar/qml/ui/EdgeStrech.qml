import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {

    id:root
    signal exitEdgeStrech();

    property int defaultMargin:10
    property int defaultProgressSize:30
    property int buttonWidth:180
    property int buttonheight:50
    property int midRectWidth:parent.width / 2

    //边缘拉伸的值
    property int edgeStrech0:0
    property int edgeStrech1:0
    property int edgeStrech2:0
    property int edgeStrech3:0

    //边缘拉伸进度
    property int currentSide:0
    property var no_0_progress:[]
    property var no_1_progress:[]
    property var no_2_progress:[]
    property var no_3_progress:[]

//    property var refreshInfoTimer:refreshInfoTimer
    property Item plt0Canvas:plt0Canvas

    //活跃边
    property int activityEdge:0

    //每条边边缘拉伸完成的状态:下标0、1、2、3分别对应0、1、2、3的边，值为0表示未完成，1表示完成
    property var edgeStrechStatus:[]
    //初始状态、完成状态、活跃点的状态颜色
    property color initColor:"gray"
    property color finishColor:"#00CC5B"
    property color activityColor:"#00B0F0"

    //提示信息
    property string tooltip:qsTr("Please draw a line next to the edge of the blue serial number, and the range of the line must cover the entire edge.");




    Rectangle{
        anchors.fill: parent

        color: "#fafafa"


        //0号板
        Rectangle{
            id:no_0_rect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: parent.width - defaultProgressSize * 2 - defaultMargin * 2
            height: defaultProgressSize
            anchors.bottom: parent.bottom
            anchors.bottomMargin: defaultMargin
            anchors.left: parent.left
            anchors.leftMargin: defaultProgressSize + defaultMargin

            Canvas{
                id:plt0Canvas
                anchors.fill:parent
                onPaint: {
                    var ctx = plt0Canvas.getContext("2d");

                    var rectWidth = (parent.width - 2)/ no_0_progress.length;
                    ctx.lineWidth = 1;


                    for(var i = no_0_progress.length - 1 ;i >= 0;i--)
                    {
                        ctx.beginPath();
                        if(no_0_progress[i] > 0)
                        {
                            ctx.fillStyle = finishColor
                            ctx.strokeStyle = finishColor
                            ctx.fillRect((no_0_progress.length - 1 - i) * rectWidth + 1,1,rectWidth,parent.height - 2);
                        }
                        else
                        {
                            ctx.fillStyle = "#fafafa";
                            ctx.strokeStyle = "#fafafa";
                            ctx.fillRect((no_0_progress.length - 1 - i) * rectWidth + 1,1,rectWidth,parent.height - 2);
                        }
                        ctx.fill();
                        ctx.stroke();
                    }
                }
            }

        }
        Rectangle{
            anchors.left:parent.left
            anchors.leftMargin: parent.width / 2
            anchors.bottom: no_0_rect.top
            anchors.bottomMargin: defaultMargin
            height:60
            width: height
            radius: width / 2
            border.color: "gray"
            border.width: 1
            Canvas{
                id:number0Canvas
                anchors.fill: parent
                onPaint: {
                    var ctx = number0Canvas.getContext("2d");
                    ctx.reset();
                    ctx.lineWidth = 1;
                    ctx.fillStyle = (activityEdge === 0 ? activityColor : (edgeStrechStatus[0] === 1 ? finishColor : "#fafafa"));
                    ctx.strokeStyle = "gray"
                    ctx.arc(parent.width / 2, parent.height / 2,parent.height / 2 - 1, 0, Math.PI*2, true);
                    ctx.fill();
                    ctx.stroke();


                    ctx.font = "40px 'Arial'";
                    ctx.fillStyle = "#000000"
                    ctx.strokeStyle = "#000000"
                    ctx.fillText("0",parent.width / 3 - 2,parent.height / 4 * 3 );

                }
            }
        }
        //1号板
        Rectangle{
            id:no_1_rect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: defaultProgressSize
            height: parent.height - defaultProgressSize * 2 - defaultMargin * 2
            anchors.right: parent.right
            anchors.rightMargin: defaultMargin
            anchors.top: parent.top
            anchors.topMargin: defaultProgressSize + defaultMargin

            Canvas{
                id:plt1Canvas
                anchors.fill:parent
                onPaint: {
                    var ctx = plt1Canvas.getContext("2d");

                    var rectHeight = (parent.height - 2)/ no_1_progress.length;
                    ctx.lineWidth = 1;
                    for(var i = 0 ;i <  no_1_progress.length;i++)
                    {
                        ctx.beginPath();
                        if(no_1_progress[i] > 0)
                        {
                            ctx.fillStyle = finishColor;
                            ctx.strokeStyle = finishColor;
                            ctx.fillRect(1,i * rectHeight + 1,parent.width - 2,rectHeight);
                        }
                        else
                        {
                            ctx.fillStyle = "#fafafa";
                            ctx.strokeStyle = "#fafafa";
                            ctx.fillRect(1,i * rectHeight + 1,parent.width - 2,rectHeight);
                        }
                        ctx.fill();
                        ctx.stroke();
                    }
                }
            }

        }
        Rectangle{
            anchors.top:parent.top
            anchors.topMargin: parent.height / 2
            anchors.right: no_1_rect.left
            anchors.rightMargin: defaultMargin
            height:60
            width: height
            radius: width / 2
            border.color: "gray"
            border.width: 1
            Canvas{
                id:number1Canvas
                anchors.fill: parent
                onPaint: {
                    var ctx = number1Canvas.getContext("2d");
                    ctx.reset();
                    ctx.lineWidth = 1;
                    ctx.fillStyle = (activityEdge === 1 ? activityColor : (edgeStrechStatus[1] === 1 ? finishColor : "#fafafa"))
                    ctx.strokeStyle = "gray"
                    ctx.arc(parent.width / 2, parent.height / 2,parent.height / 2 - 1, 0, Math.PI*2, true);
                    ctx.fill();
                    ctx.stroke();


                    ctx.font = "40px 'Arial'";
                    ctx.fillStyle = "#000000"
                    ctx.strokeStyle = "#000000"
                    ctx.fillText("1",parent.width / 3 - 2,parent.height / 4 * 3 );

                }
            }

        }
        //2号板
        Rectangle{
            id:no_2_rect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: parent.width - defaultProgressSize * 2 - defaultMargin * 2
            height: defaultProgressSize
            anchors.top: parent.top
            anchors.topMargin: defaultMargin
            anchors.left: parent.left
            anchors.leftMargin: defaultProgressSize + defaultMargin

            Canvas{
                id:plt2Canvas
                anchors.fill:parent
                onPaint: {
                    var ctx = plt2Canvas.getContext("2d");

                    var rectWidth = (parent.width - 2)/ no_2_progress.length;
                    ctx.lineWidth = 1;
                    for(var i = no_2_progress.length - 1 ;i >= 0;i--)
                    {
                        ctx.beginPath();
                        if(no_2_progress[i] > 0)
                        {
                            ctx.fillStyle = finishColor
                            ctx.strokeStyle = finishColor
                            ctx.fillRect((no_2_progress.length - 1 - i) * rectWidth + 1,1,rectWidth,parent.height - 2);
                        }
                        else
                        {
                            ctx.fillStyle = "#fafafa";
                            ctx.strokeStyle = "#fafafa";
                            ctx.fillRect((no_2_progress.length - 1 - i) * rectWidth + 1,1,rectWidth,parent.height - 2);
                        }
                        ctx.fill();
                        ctx.stroke();
                    }
                }
            }

        }
        Rectangle{
            anchors.top: no_2_rect.bottom
            anchors.topMargin: defaultMargin
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 2
            height:60
            width: height
            radius: width / 2
            border.color: "gray"
            border.width: 1
            Canvas{
                id:number2Canvas
                anchors.fill: parent
                onPaint: {
                    var ctx = number2Canvas.getContext("2d");
                    ctx.reset();
                    ctx.lineWidth = 1;
                    ctx.fillStyle = (activityEdge === 2 ? activityColor : (edgeStrechStatus[2] === 1 ? finishColor : "#fafafa"));
                    ctx.strokeStyle = "gray"
                    ctx.arc(parent.width / 2, parent.height / 2,parent.height / 2 - 1, 0, Math.PI*2, true);
                    ctx.fill();
                    ctx.stroke();


                    ctx.font = "40px 'Arial'";
                    ctx.fillStyle = "#000000"
                    ctx.strokeStyle = "#000000"
                    ctx.fillText("2",parent.width / 3 - 2,parent.height / 4 * 3 );

                }
            }
        }
        //3号板
        Rectangle{
            id:no_3_rect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: defaultProgressSize
            height: parent.height - defaultProgressSize * 2 - defaultMargin * 2
            anchors.left:parent.left
            anchors.leftMargin: defaultMargin
            anchors.top: parent.top
            anchors.topMargin: defaultProgressSize + defaultMargin

            Canvas{
                id:plt3Canvas
                anchors.fill:parent
                onPaint: {
                    var ctx = plt3Canvas.getContext("2d");

                    var rectHeight = (parent.height - 2)/ no_3_progress.length;
                    ctx.lineWidth = 1;
                    for(var i = 0 ;i <  no_3_progress.length;i++)
                    {
                        ctx.beginPath();
                        if(no_3_progress[i] > 0)
                        {
                            ctx.fillStyle = finishColor
                            ctx.strokeStyle = finishColor
                            ctx.fillRect(1,i * rectHeight + 1,parent.width - 2,rectHeight);
                        }
                        else
                        {
                            ctx.fillStyle = "#fafafa";
                            ctx.strokeStyle = "#fafafa";
                            ctx.fillRect(1,i * rectHeight + 1,parent.width - 2,rectHeight);
                        }
                        ctx.fill();
                        ctx.stroke();
                    }
                }
            }
        }
        Rectangle{
            anchors.left: no_3_rect.right
            anchors.leftMargin: defaultMargin
            anchors.top: parent.top
            anchors.topMargin: parent.height / 2
            height:60
            width: height
            radius: width / 2
            border.color: "gray"
            border.width: 1
            Canvas{
                id:number3Canvas
                anchors.fill: parent
                onPaint: {
                    var ctx = number3Canvas.getContext("2d");
                    ctx.reset();
                    ctx.lineWidth = 1;
                    ctx.fillStyle = (activityEdge === 3 ? activityColor : (edgeStrechStatus[3] === 1 ? finishColor : "#fafafa"));
                    ctx.strokeStyle = "gray"
                    ctx.arc(parent.width / 2, parent.height / 2,parent.height / 2 - 1, 0, Math.PI*2, true);
                    ctx.fill();
                    ctx.stroke();


                    ctx.font = "40px 'Arial'";
                    ctx.fillStyle = "#000000"
                    ctx.strokeStyle = "#000000"
                    ctx.fillText("3",parent.width / 3 - 2,parent.height / 4 * 3 );

                }
            }
        }

        //中间显示提示信息的方框
        Rectangle{
            id:midRect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: midRectWidth
            height: parent.height / 4
            anchors.top: parent.top
            anchors.topMargin: parent.height / 4
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - midRectWidth) / 2

            Text{
                anchors.fill: parent
                text:tooltip
                font.pointSize: 18
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        //边缘拉伸参数
        Rectangle{
            id:edgeStrechVal
            width: midRect.width
            height: 90
            color: "#fafafa"
            anchors.top: midRect.bottom
            anchors.topMargin: defaultMargin
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - midRectWidth) / 2
            Text{
                id:edgeStrechText
                anchors.left: parent.left
                width: 250
                height:(parent.height -  defaultMargin) / 2
                text:qsTr("Edge stretch value:")
                font.pointSize: 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
            Rectangle{
                id:mid_no_0
                anchors.top: parent.top
                anchors.left:edgeStrechText.right
                anchors.leftMargin: defaultMargin
                height:(parent.height -  defaultMargin) / 2
                width: height
                radius: width / 2
                border.color: "gray"
                border.width: 1
                color: "#fafafa"
                Text{
                    text:"0"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id:mid_no_0_edit
                height:(parent.height -  defaultMargin) / 2
                width:120
                border.width: 1
                color: "#fafafa"
                anchors.left: mid_no_0.right
                anchors.leftMargin: defaultMargin
                anchors.top: parent.top
                Text{
                    anchors.fill: parent
                    font.pointSize: 14
                    text:edgeStrech0
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter

                }
            }

            Rectangle{
                id:mid_no_1
                anchors.top: parent.top
                anchors.left:mid_no_0_edit.right
                anchors.leftMargin: defaultMargin * 3
                height:(parent.height -  defaultMargin) / 2
                width: height
                radius: width / 2
                border.color: "gray"
                border.width: 1
                color: "#fafafa"
                Text{
                    text:"1"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id:mid_no_1_edit
                height:(parent.height -  defaultMargin) / 2
                width:120
                border.width: 1
                color: "#fafafa"
                anchors.left: mid_no_1.right
                anchors.leftMargin: defaultMargin
                anchors.top: parent.top
                Text{
                    anchors.fill: parent
                    font.pointSize: 14
                    text:edgeStrech1
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter

                }
            }
            Rectangle{
                id:mid_no_2

                anchors.left:parent.left
                anchors.leftMargin: edgeStrechText.width + defaultMargin
                anchors.top:mid_no_0.bottom
                anchors.topMargin: defaultMargin
                height:(parent.height -  defaultMargin) / 2
                width: height
                radius: width / 2
                border.color: "gray"
                border.width: 1
                color: "#fafafa"
                Text{
                    text:"2"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id:mid_no_2_edit
                height:(parent.height -  defaultMargin) / 2
                width:120
                border.width: 1
                color: "#fafafa"
                anchors.left: mid_no_2.right
                anchors.leftMargin: defaultMargin
                anchors.top:mid_no_0_edit.bottom
                anchors.topMargin: defaultMargin

                Text{
                    anchors.fill: parent
                    font.pointSize: 14
                    text:edgeStrech2
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter

                }
            }
            Rectangle{
                id:mid_no_3
                anchors.top: mid_no_1.bottom
                anchors.topMargin: defaultMargin
                anchors.left:mid_no_2_edit.right
                anchors.leftMargin: defaultMargin * 3
                height:(parent.height -  defaultMargin) / 2
                width: height
                radius: width / 2
                border.color: "gray"
                border.width: 1
                color: "#fafafa"
                Text{
                    text:"3"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id:mid_no_3_edit
                height:(parent.height -  defaultMargin) / 2
                width:120
                border.width: 1
                color: "#fafafa"
                anchors.left: mid_no_3.right
                anchors.leftMargin: defaultMargin
                anchors.top: mid_no_1_edit.bottom
                anchors.topMargin: defaultMargin

                Text{
                    anchors.fill: parent
                    font.pointSize: 14
                    text:edgeStrech3
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter


                }
            }

        }

        //控件按钮
        Rectangle{
            width:midRect.width
            height: buttonheight
            anchors.top:edgeStrechVal.bottom
            anchors.topMargin: defaultMargin * 2
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - midRectWidth) / 2
            color: "#fafafa"

            Button{
                id:reedge_stretch
                width: buttonWidth
                height: buttonheight
                anchors.left: parent.left
                anchors.top: parent.top
                text: qsTr("Reedge stretch")
                style:ButtonStyle{
                    label: Text{
                        anchors.fill: parent
                        text:reedge_stretch.text
                        font.pointSize: 14
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: reedge_stretch.pressed ? "#c2def5" : (reedge_stretch.hovered ? "#d9ebf9" : "#cdcdcd")
                    }
                }
                onClicked: {
                    reedgeStretch();
                }

            }
            Button{
                id:nextEdge
                width: buttonWidth
                height: buttonheight
                anchors.left: reedge_stretch.right
                anchors.leftMargin: (parent.width - 4 * buttonWidth) / 3
                anchors.top: parent.top
                text: qsTr("Next side")
                style:ButtonStyle{
                    label: Text{
                        anchors.fill: parent
                        text:nextEdge.text
                        font.pointSize: 14
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: nextEdge.pressed ? "#c2def5" : (nextEdge.hovered ? "#d9ebf9" : "#cdcdcd")
                    }
                }
                onClicked: {
                    setNextActivityEdge(false);
                }

            }
            Button{
                id:paintingBoardBtn
                width: buttonWidth
                height: buttonheight
                anchors.left: nextEdge.right
                anchors.leftMargin: (parent.width - 4 * buttonWidth) / 3
                anchors.top: parent.top
                text: qsTr("Painting board")
                style:ButtonStyle{
                    label: Text{
                        anchors.fill: parent
                        text:paintingBoardBtn.text
                        font.pointSize: 14
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: paintingBoardBtn.pressed ? "#c2def5" : (paintingBoardBtn.hovered ? "#d9ebf9" : "#cdcdcd")
                    }
                }
                onClicked: {
                    touch.run("drawpanel.exe");
                }

            }
            Button{
                id:exitBtn
                width: buttonWidth
                height: buttonheight
                anchors.right: parent.right
                anchors.top: parent.top
                text: qsTr("Exit")
                style:ButtonStyle{
                    label: Text{
                        anchors.fill: parent
                        text:exitBtn.text
                        font.pointSize: 14
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: exitBtn.pressed ? "#c2def5" : (exitBtn.hovered ? "#d9ebf9" : "#cdcdcd")
                    }
                }

                onClicked: {
//                    refreshInfoTimer.stop();
                    touch.setEdgeStrechMode(false);
                    exitEdgeStrech();
                }

            }

        }






    }

//    Timer{
//        id:refreshInfoTimer
//        interval: 16
//        repeat: true
//        running: false
//        triggeredOnStart: true
//        onTriggered: {
//        }

//    }

    function startEdgeStrech()
    {
        clearPltCanvas();
        touch.setEdgeStrechMode(true);
//        refreshInfoTimer.start();
        //获取边缘拉伸的值
        getEdgeStrechVal();
        //开始边缘拉伸
        touch.startEdgeStrech();
    }
    function clearPltCanvas()
    {
        var ctx0 = plt0Canvas.getContext("2d");
        ctx0.clearRect(0,0,plt0Canvas.width,plt0Canvas.height);
        plt0Canvas.requestPaint();

        var ctx1 = plt1Canvas.getContext("2d");
        ctx0.clearRect(0,0,plt1Canvas.width,plt1Canvas.height);
        plt1Canvas.requestPaint();

        var ctx2 = plt2Canvas.getContext("2d");
        ctx0.clearRect(0,0,plt2Canvas.width,plt2Canvas.height);
        plt2Canvas.requestPaint();

        var ctx3 = plt3Canvas.getContext("2d");
        ctx0.clearRect(0,0,plt3Canvas.width,plt3Canvas.height);
        plt3Canvas.requestPaint();

        activityEdge = 0;
        for(var i = 0;i < 4;i++)
        {
            edgeStrechStatus[i] = 0;
        }
        no_0_progress.length = 0;
        no_1_progress.length = 0;
        no_2_progress.length = 0;
        no_3_progress.length = 0;

        number0Canvas.requestPaint();
        number1Canvas.requestPaint();
        number2Canvas.requestPaint();
        number3Canvas.requestPaint();

    }
    //设置下一个活跃点
    function setNextActivityEdge(flag)
    {
        if(activityEdge === 3)
        {
            if(flag)
            {
                activityEdge = -1;
            }
            else
            {
                activityEdge = 0;
            }

        }
        else
        {
            activityEdge++;
        }
        touch.setNextActivityEdge(activityEdge);

        number0Canvas.requestPaint();
        number1Canvas.requestPaint();
        number2Canvas.requestPaint();
        number3Canvas.requestPaint();

        getEdgeStrechVal();

    }

    function getEdgeStrechVal()
    {
        var datas = touch.getEdgeStrechVal();
        edgeStrech0 = datas["edgeStrech0"];
        edgeStrech1 = datas["edgeStrech1"];
        edgeStrech2 = datas["edgeStrech2"];
        edgeStrech3 = datas["edgeStrech3"];
    }

    function refreshEdgeStrechProgress(map)
    {
        var activityNum = map["activityEdge"];
        var edgeStrechDataList = map["edgeStrechDataList"];
        var i = 0;
        switch(activityNum)
        {
        case 0:
            no_0_progress.length = 0;
            for(i = 0;i < edgeStrechDataList.length;i++)
            {
                no_0_progress[i] = edgeStrechDataList[i];
            }
            plt0Canvas.requestPaint();
            break;
        case 1:
            no_1_progress.length = 0;
            for(i = 0;i < edgeStrechDataList.length;i++)
            {
                no_1_progress[i] = edgeStrechDataList[i];
            }
            plt1Canvas.requestPaint();
            break;
        case 2:
            no_2_progress.length = 0;
            for(i = 0;i < edgeStrechDataList.length;i++)
            {
                no_2_progress[i] = edgeStrechDataList[i];
            }
            plt2Canvas.requestPaint();
            break;
        case 0:
            no_3_progress.length = 0;
            for(i = 0;i < edgeStrechDataList.length;i++)
            {
                no_3_progress[i] = edgeStrechDataList[i];
            }
            plt3Canvas.requestPaint();
            break;
        }
    }

    function reedgeStretch()
    {
        var i = 0;
        clearPltCanvas();
        for(i = 0; i < 4;i++)
        {
            edgeStrechStatus[i] = 0;
        }
        no_0_progress.length = 0;
        no_1_progress.length = 0;
        no_2_progress.length = 0;
        no_3_progress.length = 0;

        if(activityEdge < 0)
        {
            activityEdge = 0;
            touch.setNextActivityEdge(activityEdge);
            touch.startEdgeStrech();
        }
        else
        {
            activityEdge = 0
            touch.setNextActivityEdge(activityEdge);
        }

        number0Canvas.requestPaint();
        number1Canvas.requestPaint();
        number2Canvas.requestPaint();
        number3Canvas.requestPaint();

        plt0Canvas.requestPaint();
        plt1Canvas.requestPaint();
        plt2Canvas.requestPaint();
        plt3Canvas.requestPaint();

        getEdgeStrechVal();
    }

}
