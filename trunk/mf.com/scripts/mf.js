// # is for id, . is for class
$(document).ready(function() {
    $("#mfFloater").dialog({
        autoOpen:false,
        height:148,
        width:140,
        dialogClass:"floatBox",
        draggable:false,
        resizable:false
    });

    $(".currentProjects").corner();
    $(".completedProjects").corner();

    $(".pool").hover(
        function () {
            show_float("images/poolSmall.jpg", "Look, a pool","270px","500px");
        },
        function() {
            close_float();
        });
    $(".poolhouse").hover(
        function () {
            show_float("images/noImageSmall.jpg", "Pool House","330px","530px");
        },
        function() {
            close_float();
        });
    $(".bonfirepit").hover(
        function () {
            show_float("images/noImageSmall.jpg", "A Place for Burning","280px","570px");
        },
        function() {
            close_float();
        });
    $(".woodpile").hover(
        function () {
            show_float("images/woodpileSmall.jpg", "Storage for Burning","250px","590px");
        },
        function() {
            close_float();
        });
    $(".blockhouse").hover(
        function () {
            show_float("images/blockhouseSmall.jpg", "Concrete Blockhouse","430px","500px");
        },
        function() {
            close_float();
        });
    $(".garage1").hover(
        function () {
            show_float("images/noImageSmall.jpg", "Garage One","430px","650px");
        },
        function() {
            close_float();
        });
    $(".garage2").hover(
        function () {
            show_float("images/noImageSmall.jpg", "Garage Two","430px","600px");
        },
        function() {
            close_float();
        });
    $(".van").hover(
        function () {
            show_float("images/noImageSmall.jpg", "Cool van, dude","400px","500px");
        },
        function() {
            close_float();
        });
    $(".johannGoal").hover(
        function () {
            show_float("images/noImageSmall.jpg", "Johann?","240px","740px");
        },
        function() {
            close_float();
        });
    $(".barn").hover(
	    function () {
		show_float("images/noImageSmall.jpg", "Big Red","460px","500px");
	    },
	    function() {
		close_float();
        });
     $(".frontHouse").hover(
                 function () {
                     show_float("images/noImageSmall.jpg", "People Go Here","440px","800px");
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
