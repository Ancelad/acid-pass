import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.acidpass.Launcher 1.0
import harbour.acidpass.Settings 1.0

Page {
    id: page
    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted

    App {
        id: bar
    }

    MySettings {
        id: myset
    }

    property string ssid_name
    property string ssid_pass
    property int echo_mode

    function loadPass() {
        var myElement
        var data = Qt.atob(
                    bar.launch(
                        "/usr/share/harbour-acid-pass/helper/acid-passhelper"))
        data = data.split('\n')
        for (var i = 0; i < data.length - 1; i++) {
            myElement = data[i].split(" | ")
            ssid_name = myElement[0]
            ssid_pass = myElement[1]
            appendList(ssid_name, ssid_pass, 2)
        }
    }

    function hideAll() {
        for (var i = listPassModel.count - 1; i >= 0; i--) {
            listPassModel.set(i, {
                                  echo_mode: 2
                              })
        }
    }

    function showAll() {
        for (var i = listPassModel.count - 1; i >= 0; i--) {
            listPassModel.set(i, {
                                  echo_mode: 0
                              })
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Activating && mainapp.fromPasswordPage) {
            if (Qt.atob(myset.value("access_code")) === mainapp.password) {
                loadPass()
            } else if (mainapp.password !== "") {
                placeholder.text = qsTr("Wrong code!")
            }
            mainapp.fromPasswordPage = false
        }
    }

    // helper function to add lists to the list
    function appendList(ssid_name, ssid_pass, echo_mode) {
        listPassModel.append({
                                 ssid_name: ssid_name,
                                 ssid_pass: ssid_pass,
                                 echo_mode: echo_mode
                             })
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        SilicaListView {
            id: listPass
            width: parent.width
            height: parent.height
            // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
            PullDownMenu {
                MenuItem {
                    text: qsTr("About")
                    onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
                }
                MenuItem {
                    text: qsTr("Change access code")
                    onClicked: {
                        mainapp.resetCode = true
                        pageStack.push(Qt.resolvedUrl("PasswordPage.qml"))
                    }
                    enabled: Qt.atob(myset.value(
                                         "access_code")) === mainapp.password
                }
            }
            PushUpMenu {
                MenuItem {
                    text: qsTr("Hide all passwords")
                    onClicked: hideAll()
                    enabled: Qt.atob(myset.value(
                                         "access_code")) === mainapp.password
                }
                MenuItem {
                    text: qsTr("Show all passwords")
                    onClicked: showAll()
                    enabled: Qt.atob(myset.value(
                                         "access_code")) === mainapp.password
                }
            }
            header: PageHeader {
                width: listPass.width
                title: qsTr("Acid-pass")
            }
            VerticalScrollDecorator {
            }
            model: ListModel {
                id: listPassModel
            }

            ViewPlaceholder {
                id: placeholder
                enabled: listPass.count === 0
                text: qsTr("No stored WiFi connections found")
            }
            delegate: ListItem {
                id: listPassItem
                menu: contextMenu
                Item {
                    // background element with diagonal gradient
                    anchors.fill: parent
                    clip: true
                    Rectangle {
                        rotation: isPortrait ? 9 : 5
                        height: parent.height
                        x: -listPass.width
                        width: listPass.width * 2

                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: Theme.rgba(Theme.primaryColor, 0)
                            }
                            GradientStop {
                                position: 1.0
                                color: Theme.rgba(Theme.primaryColor, 0.1)
                            }
                        }
                    }
                }
                IconButton {
                    id: hotspotIcon
                    icon.source: "image://theme/icon-m-wlan-hotspot"
                }

                Label {
                    id: nameLabel
                    anchors.left: hotspotIcon.right
                    text: ssid_name
                    font.pixelSize: Theme.fontSizeMedium
                    truncationMode: TruncationMode.Fade
                }
                TextField {
                    id: passLabel
                    text: ssid_pass
                    font.family: 'monospace'
                    x: hotspotIcon.width - Theme.paddingLarge // align with ssid name
                    anchors.top: nameLabel.bottom
                    font.pixelSize: Theme.fontSizeSmall
                    echoMode: echo_mode === 0 ? TextInput.Normal : TextInput.Password
                    enabled: false
                    readOnly: true
                    color: Theme.highlightColor
                }
                Component {
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: qsTr("Copy password to clipboard")
                            onClicked: {
                                Clipboard.text = ssid_pass
                            }
                        }
                    }
                }
                onClicked: {
                    if (echo_mode === 2) {
                        listPassModel.set(index, {
                                              echo_mode: 0
                                          })
                    } else {
                        listPassModel.set(index, {
                                              echo_mode: 2
                                          })
                    }
                }
            }
        }
    }
}
