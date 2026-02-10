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

    // Анализ эффективности на основе падения пульса
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

        // Заголовок
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, 35, Graphics.FONT_TINY, "ИТОГИ СЕССИИ", Graphics.TEXT_JUSTIFY_CENTER);

        // Блок аналитики (Эффективность)
        var resultText = calculateEffectiveness();
        var resultColor = (_startHR > _endHR) ? Graphics.COLOR_GREEN : Graphics.COLOR_YELLOW;
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, 65, Graphics.FONT_XTINY, "ЭФФЕКТИВНОСТЬ:", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(resultColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, 85, Graphics.FONT_SMALL, resultText, Graphics.TEXT_JUSTIFY_CENTER);

        // Разделительная линия
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(w * 0.2, h / 2, w * 0.8, h / 2);

        // Сетка данных (Время и Циклы)
        drawStat(dc, w/2 - 55, h/2 + 10, "ВРЕМЯ", formatTime(_duration));
        drawStat(dc, w/2 + 55, h/2 + 10, "ЦИКЛЫ", _cycles.toString());
        
        // Визуализация пульса
        drawHRScale(dc, w/2, h - 60, _startHR, _endHR);

        // Подсказка для выхода
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h - 25, Graphics.FONT_XTINY, "Нажми BACK для выхода", Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Рисует графическую шкалу пульса
    function drawHRScale(dc, x, y, start, end) {
        var barWidth = 120;
        
        // Базовая линия
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawLine(x - barWidth/2, y, x + barWidth/2, y);

        // Начальный пульс
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - barWidth/2, y, 5);
        dc.drawText(x - barWidth/2, y + 10, Graphics.FONT_XTINY, start.toString(), Graphics.TEXT_JUSTIFY_CENTER);

        // Конечный пульс
        var endColor = (start > end) ? Graphics.COLOR_GREEN : Graphics.COLOR_RED;
        dc.setColor(endColor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x + barWidth/2, y, 7);
        dc.drawText(x + barWidth/2, y + 10, Graphics.FONT_XTINY, end.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        
        // Подпись
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 25, Graphics.FONT_XTINY, "PULSE: START > END", Graphics.TEXT_JUSTIFY_CENTER);
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
    function initialize() {
        BehaviorDelegate.initialize();
    }
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}