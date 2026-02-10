import Toybox.WatchUi;
import Toybox.Graphics;

class SummaryView extends WatchUi.View {
    private var _duration, _cycles, _startHR, _endHR;

    function initialize(duration, cycles, startHR, endHR) {
        View.initialize();
        _duration = duration;
        _cycles = cycles;
        _startHR = startHR;
        _endHR = endHR;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        var w = dc.getWidth();
        var h = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, 40, Graphics.FONT_MEDIUM, "ИТОГИ СЕССИИ", Graphics.TEXT_JUSTIFY_CENTER);

        // Сетка данных
        drawStat(dc, w/2 - 50, h/2 - 30, "ВРЕМЯ", formatTime(_duration));
        drawStat(dc, w/2 + 50, h/2 - 30, "ЦИКЛЫ", _cycles.toString());
        
        // Пульс
        var hrDiff = _startHR - _endHR;
        var hrColor = (hrDiff > 0) ? Graphics.COLOR_GREEN : Graphics.COLOR_WHITE;
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w/2, h/2 + 40, Graphics.FONT_XTINY, "ПУЛЬС (НАЧ / КОН)", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(hrColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w/2, h/2 + 65, Graphics.FONT_MEDIUM, _startHR + " > " + _endHR, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawStat(dc, x, y, label, value) {
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 25, Graphics.FONT_SMALL, value, Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function formatTime(seconds) {
        return (seconds / 60).toNumber() + ":" + (seconds % 60).format("%02d");
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