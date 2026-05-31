pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.clock
import org.kde.plasma.workspace.calendar as PlasmaCalendar
import org.kde.plasma.plasma5support as P5Support

PlasmoidItem {
    id: main

    readonly property bool inVerticalBar: Plasmoid.formFactor == PlasmaCore.Types.Vertical
    readonly property bool inHorizontalBar: Plasmoid.formFactor == PlasmaCore.Types.Horizontal

    readonly property string imagePath: Plasmoid.configuration.imagePath
    property string currentImagePath: ""

    readonly property string cmdline: "IMAGE_PATH=\"" + main.imagePath + "\"; " + Plasmoid.configuration.cmdline

    Clock {
        id: clockSource
        trackSeconds: Plasmoid.configuration.seconds
    }

    P5Support.DataSource {
        id: cmdlineDataSource

        engine: 'executable'

        onNewData: (source, data) => {
            //console.log("Received new data from executable: " + JSON.stringify(data))
            connectedSources.length = 0
            if (data['exit code'] == 0) {
                main.currentImagePath = ""
                main.currentImagePath = main.imagePath
            }
        }
    }

    property Component clockComponent: MouseArea {
        property bool wasExpanded
        onPressed: wasExpanded = main.expanded
        onClicked: main.expanded = !wasExpanded

        Layout.fillWidth: !inHorizontalBar
        Layout.fillHeight: !inVerticalBar
        Layout.minimumWidth: inHorizontalBar ?height / image.sourceSize.height * image.sourceSize.width : 0
        Layout.minimumHeight: inVerticalBar ?width / image.sourceSize.width * image.sourceSize.height : 0

        readonly property var currentTime: clockSource.dateTime
        onCurrentTimeChanged: {
            //console.log("Current time changed: " + currentTime.toString())
            if (cmdline.length > 0 && cmdlineDataSource.connectedSources.length == 0) {
                cmdlineDataSource.connectSource(cmdline)
            } else {
                main.currentImagePath = ""
                main.currentImagePath = main.imagePath
            }
        }

        Image {
            id: image

            anchors.fill: parent            
            fillMode: Image.PreserveAspectFit        
            cache: false
            source: main.currentImagePath
        }
    }

    compactRepresentation: clockComponent

    fullRepresentation: PlasmaCalendar.MonthView {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 22
        Layout.maximumWidth: Kirigami.Units.gridUnit * 80
        Layout.minimumHeight: Kirigami.Units.gridUnit * 22
        Layout.maximumHeight: Kirigami.Units.gridUnit * 40

        readonly property var appletInterface: main

        today: clockSource.dateTime
    }

    preferredRepresentation: compactRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
}
