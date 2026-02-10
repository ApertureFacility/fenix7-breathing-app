import Toybox.WatchUi;
import Toybox.Graphics;

class SummaryView extends WatchUi.View {
    private var _duration;

    function initialize(duration) {
        View.initialize();
        _duration = duration;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var w = dc.getWidth();
        var h = dc.getHeight();

        dc.drawText(w / 2, h / 2 - 40, Graphics.FONT_MEDIUM, "Готово!", Graphics.TEXT_JUSTIFY_CENTER);
        
        var minutes = (_duration / 60).toNumber();
        var seconds = (_duration % 60).toNumber();
        var timeStr = Lang.format("$1$ мин $2$ сек", [minutes, seconds]);

        dc.drawText(w / 2, h / 2, Graphics.FONT_SMALL, "Время сессии:", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 2 + 30, Graphics.FONT_MEDIUM, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h - 40, Graphics.FONT_XTINY, "Нажмите BACK для выхода", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

// Делегат для выхода из итогов в главное меню
class SummaryDelegate extends WatchUi.BehaviorDelegate {
    function initialize() { BehaviorDelegate.initialize(); }
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}