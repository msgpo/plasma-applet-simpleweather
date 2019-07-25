import QtQuick 2.7
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0 as QtQuickControlsPrivate
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.weather 1.0 as WeatherPlugin

ColumnLayout {
	id: currentWeatherView

	spacing: 0

	opacity: weatherData.hasData ? 1 : 0
	Behavior on opacity { NumberAnimation { duration: 1000 } }

	readonly property string fontFamily: plasmoid.configuration.fontFamily || theme.defaultFont.family
	readonly property var fontBold: plasmoid.configuration.bold ? Font.Bold : Font.Normal

	readonly property int minMaxFontSize: plasmoid.configuration.minMaxFontSize * units.devicePixelRatio
	readonly property int forecastFontSize: plasmoid.configuration.forecastFontSize * units.devicePixelRatio

	readonly property int minMaxSeparatorWidth: minMaxFontSize * 1.4


	RowLayout {
		spacing: units.smallSpacing

		ColumnLayout {
			spacing: units.smallSpacing

			PlasmaComponents.Label {
				readonly property var value: weatherData.todaysTempHigh
				readonly property bool hasValue: !isNaN(value)
				text: hasValue ? i18n("%1°", value) : ""
				Layout.preferredWidth: hasValue ? implicitWidth : 0
				font.pointSize: -1
				font.pixelSize: currentWeatherView.minMaxFontSize
				font.family: currentWeatherView.fontFamily
				font.weight: currentWeatherView.fontBold
				Layout.alignment: Qt.AlignHCenter

				// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#f00"}
			}

			Rectangle {
				visible: !isNaN(weatherData.todaysTempHigh) || !isNaN(weatherData.todaysTempLow)
				color: theme.textColor
				implicitWidth: currentWeatherView.minMaxSeparatorWidth
				implicitHeight: 1 * units.devicePixelRatio
				Layout.alignment: Qt.AlignHCenter
			}


			PlasmaComponents.Label {
				readonly property var value: weatherData.todaysTempLow
				readonly property bool hasValue: !isNaN(value)
				text: hasValue ? i18n("%1°", value) : ""
				Layout.preferredWidth: hasValue ? implicitWidth : 0
				font.pointSize: -1
				font.pixelSize: currentWeatherView.minMaxFontSize
				font.family: currentWeatherView.fontFamily
				font.weight: currentWeatherView.fontBold
				Layout.alignment: Qt.AlignHCenter

				// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#f00"}
			}
		}

		Item {
			implicitWidth: currentTempLabel.hasValue ? currentTempLabel.contentWidth : currentForecastIcon.implicitWidth
			Layout.minimumWidth: implicitWidth
			Layout.minimumHeight: 18 * units.devicePixelRatio
			Layout.alignment: Qt.AlignHCenter
			Layout.fillHeight: true

			// Note: wettercom does not have a current temp
			PlasmaComponents.Label {
				id: currentTempLabel
				anchors.centerIn: parent
				readonly property var value: weatherData.currentTemp
				readonly property bool hasValue: !isNaN(value)
				text: hasValue ? i18n("%1°", Math.round(value)) : ""
				fontSizeMode: Text.FixedSize
				font.pointSize: -1
				font.pixelSize: parent.height
				height: implicitHeight
				font.family: currentWeatherView.fontFamily
				font.weight: currentWeatherView.fontBold

				// Workaround for Issue #9 where Plasma might crash in OpenSuse if
				// the Text is larger than 320px and using NativeRendering. Manjaro
				// does not crash, instead it draws nothing.
				// * https://github.com/Zren/plasma-applet-simpleweather/issues/9
				// * https://github.com/KDE/plasma-framework/blob/master/src/declarativeimports/plasmacomponents/qml/Label.qml
				readonly property var plasmaRenderingType: QtQuickControlsPrivate.Settings.isMobile || Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
				renderType: height > 300 ? Text.QtRendering : plasmaRenderingType

				// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#ff0" }
			}

			// Note: wettercom does not have a current temp so use an icon instead
			PlasmaCore.IconItem {
				id: currentForecastIcon
				anchors.centerIn: parent
				implicitWidth: parent.height
				implicitHeight: parent.height
				visible: !currentTempLabel.hasValue
				source: weatherData.currentConditionIconName
				roundToIconSize: false
			}

			// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#f00"}
		}
	}

	PlasmaComponents.Label {
		text: weatherData.todaysForecastLabel
		font.pointSize: -1
		font.pixelSize: currentWeatherView.forecastFontSize
		font.family: currentWeatherView.fontFamily
		font.weight: currentWeatherView.fontBold
		Layout.alignment: Qt.AlignHCenter

		// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#f00"}
	}

}
