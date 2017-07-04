/*
 * Copyright (C) 2013 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

/*
   Essentially a GridView
 */
Item {
    property int minimumHorizontalSpacing: units.gu(0.5)
    property alias columns: gridView.columns
    property alias verticalSpacing: gridView.verticalSpacing
    readonly property alias margins: gridView.margin
    property int delegateWidth
    property int delegateHeight
    property alias model: gridView.model
    property alias delegate: gridView.delegate
    readonly property int cellWidth: gridView.cellWidth
    readonly property int cellHeight: gridView.cellHeight
    readonly property int totalContentHeight: {
        if (gridView.model) {
            return contentHeightForRows(Math.ceil(gridView.model.count / columns), cellHeight)
        } else {
            return 0;
        }
    }
    property alias interactive: gridView.interactive
    readonly property alias flicking: gridView.flicking
    readonly property alias moving: gridView.moving
    readonly property alias pressDelay: gridView.pressDelay
    readonly property alias originY: gridView.originY
    property alias displayMarginBeginning: gridView.displayMarginBeginning
    property alias displayMarginEnd: gridView.displayMarginEnd
    property alias highlightIndex: gridView.highlightIndex
    property alias cacheBuffer: gridView.cacheBuffer
    readonly property alias currentItem: gridView.currentItem
    property alias view: gridView

    function contentHeightForRows(rows, height) {
        return rows * height
    }

    GridView {
        id: gridView
        objectName: "responsiveGridViewGrid"
        anchors {
            fill: parent
            //leftMargin: margin/2//margin/2 + horizontalSpacing / 2
            //rightMargin: margin/2//margin/2 - horizontalSpacing / 2
        }
        clip: parent.height != totalContentHeight

        function pixelToGU(value) {
            return Math.floor(value / units.gu(1));
        }

        function spacingForColumns(columns) {
            // spacing between columns as an integer number of GU, the remainder goes in the margins
            var spacingGU = pixelToGU(allocatableHorizontalSpace / columns);
            return units.gu(spacingGU);
        }

        function columnsForSpacing(spacing) {
            // minimum margin is half of the spacing
            return Math.max(1, Math.floor(parent.width / (delegateWidth + spacing)));
        }

        property real allocatableHorizontalSpace: parent.width - columns * delegateWidth
        property int columns: 4 //columnsForSpacing(minimumHorizontalSpacing)
        property real horizontalSpacing: spacingForColumns(columns)
        property real verticalSpacing: horizontalSpacing
        property int margin: gridView.width - cellWidth * columns //allocatableHorizontalSpace - columns * horizontalSpacing
        property int highlightIndex: -1

        cellWidth: Math.floor(gridView.width / columns) //delegateWidth// + horizontalSpacing
        cellHeight: delegateHeight + verticalSpacing

        onHighlightIndexChanged: {
            if (highlightIndex != -1) {
                currentIndex = highlightIndex
            }
        }
    }
}
