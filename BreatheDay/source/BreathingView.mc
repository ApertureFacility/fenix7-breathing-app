using Toybox.WatchUi;
using Toybox.Graphics;

class BreathingView extends WatchUi.View {

    var mode;

    function initialize(modeId) {
        View.initialize();
        mode = modeId;
    }

    function onUpdate(dc) {
        dc.clear();
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_LARGE,
            "Режим: " + mode,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}
