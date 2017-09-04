// Largely cribbed from https://github.com/elm-lang/dom/blob/1.1.1/src/Native/Dom.js

var _fisxoj$elm_media$Native_Media = function() {

    var rAF = typeof requestAnimationFrame !== 'undefined'
	? requestAnimationFrame
        : function(callback) { callback(); };

    function withNode(id, doStuff) {
	return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
	    rAF(function() {
		var node = document.getElementById(id);
		if (node === null) {
		    callback(_elm_lang$core$Native_Scheduler.fail({ ctor: 'NotFound', _0: id }));
		    return;
		}
		callback(_elm_lang$core$Native_Scheduler.succeed(doStuff(node)));
	    });
	});
    }

    function seek(id, targetTime) {
        return withNode(id, function (element) {
            element.currentTime = targetTime;
            return { ctor: 'Preroll'};
        });
    }

    function play(id) {
        return withNode(id, function (element) {
            element.play();
            return { ctor: 'Playing'};
        });
    }

    function pause(id) {
        return withNode(id, function (element) {
            element.pause();
            return { ctor: 'Paused' };
        });
    }

    return {
        play: play,
        pause: pause,
        seek: seek
    };
}();
