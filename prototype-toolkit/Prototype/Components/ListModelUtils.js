.pragma library

function each(listModel, cb) {
    var len = listModel.count
    var item = null
    for (var i = 0; i < len; i++) {
        item = listModel.get(i)
        if (cb.call(item, item, i) === false) return
    }
}

function arrayFromListModel(listModel) {
    var arr = []
    each(listModel, function() {
        arr.push(this)
    })
    return arr
}

function find(listModel, cb) {
    var found = null
    each(listModel, function(item, index) {
        if (cb.call(item, item, index)) {
            found = item
            return false
        }
    })
    return found
}

function findIndex(listModel, cb) {
    var found = null
    each(listModel, function(item, index) {
        if (cb.call(item, item, index)) {
            found = index
            return false
        }
    })
    return found
}

function eachForArray(array, cb) {
    var len = array.length
    var item = null
    for (var i = 0; i < len; i++) {
        item = array[i]
        if (cb.call(item, item, i) === false) return
    }
}

function findFromArray(array, cb) {
    var found = null
    eachForArray(array, function(item, index) {
        if (cb.call(item, item, index)) {
            found = item
            return false
        }
    })
    return found
}
