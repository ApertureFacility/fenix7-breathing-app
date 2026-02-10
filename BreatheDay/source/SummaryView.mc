import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class SummaryView extends WatchUi.View {
    // 1. Добавили _hrv в список переменных класса
    private var _duration, _cycles, _startHR, _endHR, _hrv;

    // 2. Добавили hrv в аргументы (теперь их 5)
    function initialize(duration, cycles, startHR, endHR, hrv) {
        View.initialize();
        _duration = duration;
        _cycles = cycles;
        _startHR = startHR;
        _endHR = endHR;
        _hrv = hrv; // Теперь ошибка "Undefined symbol" исчезнет
    }

    function calculateEffectiveness() {
        if (_startHR <= 0 || _endHR <= 0) { return "НЕТ ДАННЫХ"; }
        var diff = _startHR - _endHR;
        var percentDrop = (diff.toFloat() / _startHR.toFloat()) * 100;

        if (percentDrop > 15) { return "ОТЛИЧНО (ДЗЕН)"; }
        if (percentDrop > 5)  { return "ХОРОШО (РЕЛАКС)"; }
        if (percentDrop > 0)  { return "СТАБИЛЬНО"; }
        return "НУЖНА ПРАКТИКА";
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var h = dc.getHeight();
        var w = dc.getWidth();

        // Заголовок
        dc.drawText(w/2, h*0.15, Graphics.FONT_TINY, "ИТОГИ", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Эффективность (текстом)
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w/2, h*0.28, Graphics.FONT_XTINY, calculateEffectiveness(), Graphics.TEXT_JUSTIFY_CENTER);

        // Шкала пульса (визуальная)
        drawHRScale(dc, w/2, h*0.5, _startHR, _endHR);

        // Статистика внизу
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        // Время и Циклы
        var timeStr = formatTime(_duration);
        drawStat(dc, w*0.3, h*0.7, "ВРЕМЯ", timeStr);
        drawStat(dc, w*0.7, h*0.7, "ЦИКЛЫ", _cycles.toString());
        
        // Вывод HRV (Вариабельность)
        var hrvValue = (_hrv != null && _hrv > 0) ? _hrv.toString() + " ms" : "--";
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w/2, h*0.88, Graphics.FONT_XTINY, "HRV: " + hrvValue, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawHRScale(dc, x, y, start, end) {
        var barWidth = 140;
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 35, Graphics.FONT_XTINY, "PULSE: START > END", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawLine(x - barWidth/2, y, x + barWidth/2, y);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - barWidth/2, y, 5);
        dc.drawText(x - barWidth/2, y + 10, Graphics.FONT_XTINY, start.toString(), Graphics.TEXT_JUSTIFY_CENTER);

        var endColor = (start > end) ? Graphics.COLOR_GREEN : (start < end ? Graphics.COLOR_RED : Graphics.COLOR_WHITE);
        dc.setColor(endColor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x + barWidth/2, y, 7);
        dc.drawText(x + barWidth/2, y + 10, Graphics.FONT_XTINY, end.toString(), Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawStat(dc, x, y, label, value) {
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 20, Graphics.FONT_SMALL, value, Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function formatTime(seconds) {
        var min = (seconds / 60).toNumber();
        var sec = (seconds % 60).toNumber();
        return min + ":" + sec.format("%02d");
    }
}

class SummaryDelegate extends WatchUi.BehaviorDelegate {
    function initialize() { BehaviorDelegate.initialize(); }
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}