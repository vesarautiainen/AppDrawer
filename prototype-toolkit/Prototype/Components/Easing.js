.pragma library

// Standard simplified easing functions

// no easing, no acceleration
var linear = function (t) { return t }
// accelerating from zero velocity
var easeInQuad = function (t) { return t*t }
// decelerating to zero velocity
var easeOutQuad = function (t) { return t*(2-t) }
// acceleration until halfway, then deceleration
var easeInOutQuad = function (t) { return t<.5 ? 2*t*t : -1+(4-2*t)*t }
// accelerating from zero velocity
var easeInCubic = function (t) { return t*t*t }
// decelerating to zero velocity
var easeOutCubic = function (t) { return (--t)*t*t+1 }
// acceleration until halfway, then deceleration
var easeInOutCubic = function (t) { return t<.5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1 }
// accelerating from zero velocity
var easeInQuart = function (t) { return t*t*t*t }
// decelerating to zero velocity
var easeOutQuart = function (t) { return 1-(--t)*t*t*t }
// acceleration until halfway, then deceleration
var easeInOutQuart = function (t) { return t<.5 ? 8*t*t*t*t : 1-8*(--t)*t*t*t }
// accelerating from zero velocity
var easeInQuint = function (t) { return t*t*t*t*t }
// decelerating to zero velocity
var easeOutQuint = function (t) { return 1+(--t)*t*t*t*t }
// acceleration until halfway, then deceleration
var easeInOutQuint = function (t) { return t<.5 ? 16*t*t*t*t*t : 1+16*(--t)*t*t*t*t }


//----------------------------------
// my own custom easings
function switchEasing(t, threshold) {
    var th = threshold
    if(t < th) return cubicInOut(t*1/th)
    else return 1 - cubicOut((t - th)*1/(1-th))
}

function switchEasing2(t, threshold) {
    var th = threshold
    if(t < th) return cubicIn(t*1/th)
    else return 1 - cubicOut((t - th)*1/(1-th))
}

function switchEasing3(t, threshold) {
    var th = threshold
    if(t < th) return cubicOut(t*1/th)
    else return 1 - cubicOut((t - th)*1/(1-th))
}

function switchEasing4(t, threshold) {
    var th = threshold
    if (t < th) return easeOutCubic(t*1/th)
    else return 1 - easeInOutCubic((t - th)*1/(1-th))
}
