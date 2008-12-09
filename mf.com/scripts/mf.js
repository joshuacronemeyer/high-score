$(document).ready(function() {
    $("#mfFloater").dialog({
        autoOpen:false,
        height:160,
        width:140,
        dialogClass:"floatBox",
        draggable:false,
        resizable:false
    });
    $(".pool").hover(
        function () {
            show_float("images/poolSmall.jpg", "Look, a pool","250px","530px");
        },
        function() {
            close_float();
        });
    $(".poolhouse").hover(
        function () {
            show_float("images/pool/pool_ls.jpg", "Pool House","250px","530px");
        },
        function() {
            close_float();
        });
    $(".bonfirepit").hover(
        function () {
            show_float("images/pool/pool_ls.jpg", "A Place for Burning","250px","600px");
        },
        function() {
            close_float();
        });
    $(".blockhouse").hover(
        function () {
            show_float("images/blockhouse/gym1.jpg", "Concrete Blockhouse","360px","400px");
        },
        function() {
            close_float();
        });
});
function show_float(image, title, top, left) {
    $("#mfFloater").dialog("open");
    $("#floaterPic").attr({src: image});
    $("#ui-dialog-title-mfFloater").text(title);
    $(".ui-dialog").css("top",top);
    $(".ui-dialog").css("left",left);
}

function close_float() {
    $("#mfFloater").dialog("close");
}