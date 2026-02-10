using Toybox.WatchUi;

class ModeMenuView extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Режим дыхания"});

        // Arguments: label, subLabel, identifier, options
        addItem(new WatchUi.MenuItem("Равномерное", null, :even, null));
        addItem(new WatchUi.MenuItem("4-4-4", "Square breathing", :box, null));
        addItem(new WatchUi.MenuItem("4-7-8", "Relaxation", :fourSevenEight, null));
    }
}