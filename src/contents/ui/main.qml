pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.clock
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

    property Component clockComponent: Image {
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
        
        Layout.fillWidth: !inHorizontalBar
        Layout.fillHeight: !inVerticalBar
        Layout.minimumWidth: inHorizontalBar ?height / sourceSize.height * sourceSize.width : 0
        Layout.minimumHeight: inVerticalBar ?width / sourceSize.width * sourceSize.height : 0        
        fillMode: Image.PreserveAspectFit        
        cache: false
        source: main.currentImagePath
    }

    compactRepresentation: clockComponent
    fullRepresentation: clockComponent
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
}
