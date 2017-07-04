.pragma library

// A .pragma library JS file can not access the Component object yet.
// https://www.mail-archive.com/qt-qml@trolltech.com/msg01643.html
var COMPONENT_READY = 1
var COMPONENT_LOADING = 1
var COMPONENT_ERROR = 3

/**
 * Convert a rect-like object into a QML rect
 */
function toRect(obj) {
    return Qt.rect(obj.x, obj.y, obj.width, obj.height)
}

/**
 * Returns the nested children of an item for a given position.
 *
 * @param {object} item the container
 * @param {number} x position on x
 * @param {number} y position on y
 * @return {array} the children list
 */
function childrenAt(item, x, y) {
    var parentItem = item
    var coords = { x: x, y: y }
    var children = []
    while (item = parentItem.childAt(coords.x, coords.y)) {
        coords = item.mapFromItem(parentItem, coords.x, coords.y)
        children.push(parentItem = item)
    }
    return children
}

/**
 * Returns the most nested item in the visible components list.
 *
 * @param {object} item the container
 * @param {number} x position on x
 * @param {number} y position on y
 */
function lastChildAt(item, x, y) {
    var children = childrenAt(item, x, y)
    return children.length? children[children.length-1] : item
}

/**
 * Return the top-level item in the document tree
 */
function getRootItem(item) {
    var currentItem = item
    while (currentItem.parent) {
        currentItem = currentItem.parent
    }
    return currentItem
}

/**
 * Create and return an item based on a component definition
 */
function createItem(componentPath, parent, opts, callback) {
    if (!callback && typeof opts === 'function') {
        callback = opts
    }
    var component = Qt.createComponent(componentPath)
    var create = function() {
        return component.createObject(parent, opts || {})
    }
    var callbackIfReady = function() {
        var ready = component.status === COMPONENT_READY
        var error = component.status === COMPONENT_ERROR
        if (ready) {
            callback(create())
        }
        if (error) {
            console.debug('Error: ' + component.errorString())
        }
        return ready
    }
    if (!callbackIfReady()) {
        component.onStatusChanged = callbackIfReady
    }
}
