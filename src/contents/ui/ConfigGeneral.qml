import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

KCM.SimpleKCM {
    id: root

    property alias cfg_cmdline: cmdline.text
	property alias cfg_imagePath: imagePath.text
	property alias cfg_seconds: seconds.checked

	readonly property bool inVerticalBar: Plasmoid.formFactor == PlasmaCore.Types.Vertical
	readonly property bool inHorizontalBar: Plasmoid.formFactor == PlasmaCore.Types.Horizontal

	Kirigami.FormLayout {

		Kirigami.ActionTextField {
			id: cmdline
			Kirigami.FormData.label: i18n("Command line:")
			wrapMode: TextEdit.Wrap
			Layout.minimumWidth: 600
		}

		Kirigami.ActionTextField {
			id: imagePath
			Kirigami.FormData.label: i18n("Image path:")
		}

        ColumnLayout {
			Kirigami.FormData.label: i18n("Update interval:")
            RadioButton {
				id: minutes
                text: qsTr("Minute")
            }
            RadioButton {
				id: seconds
                text: qsTr("Second")
            }
        }
	}
}
