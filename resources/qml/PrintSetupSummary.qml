// Copyright (c) 2020 Aldo Hoeben / fieldOfView
// SidebarGUIPlugin is released under the terms of the AGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura

Cura.RoundedRectangle
{
    property bool summaryEnabled: (prepareStageActive || !preSlicedData)

    color:
    {
        if (!summaryEnabled)
        {
            return UM.Theme.getColor("action_button_disabled")
        }
        else if (mouseArea.containsMouse)
        {
            return UM.Theme.getColor("action_button_hovered")
        }
        return UM.Theme.getColor("action_button")
    }

    border.width: UM.Theme.getSize("default_lining").width
    border.color: UM.Theme.getColor("lining")
    radius: UM.Theme.getSize("default_radius").width
    cornerSide: Cura.RoundedRectangle.Direction.Left

    height:
    {
        var result = printSetupSummary.height + 2 * UM.Theme.getSize("default_margin").height
        if (extruderSummary.visible)
        {
            result += extruderSummary.height + UM.Theme.getSize("default_margin").height
        }
        return result
    }

    Cura.PrintSetupSelectorHeader
    {
        id: printSetupSummary
        visible: summaryEnabled

        anchors
        {
            left: parent.left
            right: collapseButton.left
            top: parent.top

            leftMargin: UM.Theme.getSize("default_margin").width
            topMargin: UM.Theme.getSize("default_margin").width
        }
    }

    UM.RecolorImage
    {
        id: collapseButton
        anchors
        {
            verticalCenter: printSetupSummary.verticalCenter

            right: parent.right
            rightMargin: UM.Theme.getSize("default_margin").width
        }
        source: UM.Theme.getIcon("pencil")
        visible: summaryEnabled
        width: UM.Theme.getSize("action_button_icon").width
        height: UM.Theme.getSize("action_button_icon").height
        color: UM.Theme.getColor("small_button_text")
    }

    property bool hasMaterials:
    {
        if (CuraSDKVersion >= "6.2.0") {
            return (Cura.MachineManager.activeMachine != null) ? Cura.MachineManager.activeMachine.hasMaterials : false
        } else {
            return Cura.MachineManager.hasMaterials
        }
    }
    property bool hasVariants:
    {
        if (CuraSDKVersion >= "6.2.0") {
            return (Cura.MachineManager.activeMachine != null) ? Cura.MachineManager.activeMachine.hasVariants : false
        } else {
            return Cura.MachineManager.hasVariants
        }
    }

    ExtruderTabs
    {
        id: extruderSummary
        enabled: false
        visible: summaryEnabled && (hasMaterials || hasVariants)

        anchors
        {
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            leftMargin: UM.Theme.getSize("default_margin").width
            rightMargin: UM.Theme.getSize("default_margin").width
            bottomMargin: UM.Theme.getSize("default_margin").width
        }
    }

    Label
    {
        visible: !summaryEnabled
        anchors.top: parent.top
        anchors.topMargin: UM.Theme.getSize("thick_margin").height
        anchors.left: parent.left
        anchors.leftMargin: UM.Theme.getSize("thick_margin").height
        width: parent.width
        font: UM.Theme.getFont("medium_bold")
        color: UM.Theme.getColor("text")
        renderType: Text.NativeRendering

        text: catalog.i18nc("@label shown when we load a Gcode file", "Print setup disabled. G-code file can not be modified.")
    }

    MouseArea
    {
        id: mouseArea
        hoverEnabled: true
        enabled: summaryEnabled
        anchors.fill: parent

        onClicked:
        {
            UM.Preferences.setValue("view/settings_visible", true)
        }
    }
}
