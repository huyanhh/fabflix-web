var dialog = false;
const time_delay = 500;
var timer;

//gets called to open up the dialog box
function popDialogInt(event)
{
    var dialog_id = "d" + event.target.id;
    if (!dialog) {
        $("#" + dialog_id).dialog();
        dialog = true;
        
        $("#" + dialog_id).on("dialogclose", function (event) {
            dialog = false;
        });
    }
}

//creates the time delay for mouse over
function popDialog(event) 
{
    timer = setTimeout(popDialogInt, time_delay, event);
}

//resets timer after exiting dialog box
function removeDialog()
{
    clearTimeout(timer);
}
