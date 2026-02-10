import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class SummaryView extends WatchUi.View {
    private var _duration, _cycles, _startHR, _endHR;

    function initialize(duration, cycles, startHR, endHR) {
        View.initialize();
        _duration = duration;
        _cycles = cycles;
        _startHR = startHR;
        _endHR = endHR;
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
        
        var w = dc.getWidth();
        var h = dc.getHeight();

        // 1. ВЕРХ: Заголовок и Результат
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h * 0.15, Graphics.FONT_XTINY, "ИТОГИ СЕССИИ", Graphics.TEXT_JUSTIFY_CENTER);

        var resultText = calculateEffectiveness();
        var resultColor = (_startHR > _endHR) ? Graphics.COLOR_GREEN : Graphics.COLOR_YELLOW;
        dc.setColor(resultColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h * 0.25, Graphics.FONT_SMALL, resultText, Graphics.TEXT_JUSTIFY_CENTER);

        // 2. ЦЕНТР: Статистика
        drawStat(dc, w/2 - 55, h/2 - 20, "ВРЕМЯ", formatTime(_duration));
        drawStat(dc, w/2 + 55, h/2 - 20, "ЦИКЛЫ", _cycles.toString());
        
        // Линия-разделитель (чуть выше, чем была)
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(w * 0.25, h/2 + 30, w * 0.75, h/2 + 30);

        // 3. НИЗ: Шкала пульса
        // Используем h * 0.78 чтобы опустить всю конструкцию ниже
        drawHRScale(dc, w/2, h * 0.78, _startHR, _endHR);
    }

    function drawHRScale(dc, x, y, start, end) {
        var barWidth = 120;
        
        // Подпись: теперь она выше линии на 25 пикселей (хороший отступ)
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 25, Graphics.FONT_XTINY, "PULSE: START > END", Graphics.TEXT_JUSTIFY_CENTER);

        // Базовая линия
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawLine(x - barWidth/2, y, x + barWidth/2, y);

        // Начальный пульс (белая точка)
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - barWidth/2, y, 5);
        dc.drawText(x - barWidth/2, y + 10, Graphics.FONT_XTINY, start.toString(), Graphics.TEXT_JUSTIFY_CENTER);

        // Конечный пульс (цветная точка)
        var endColor = (start > end) ? Graphics.COLOR_GREEN : Graphics.COLOR_RED;
        dc.setColor(endColor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x + barWidth/2, y, 7);
        dc.drawText(x + barWidth/2, y + 10, Graphics.FONT_XTINY, end.toString(), Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawStat(dc, x, y, label, value) {
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 22, Graphics.FONT_SMALL, value, Graphics.TEXT_JUSTIFY_CENTER);
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